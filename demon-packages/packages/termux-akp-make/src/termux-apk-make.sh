#!/bin/bash

set -euo pipefail
trap 'echo "Error en línea $LINENO. Código de salida: $?" >&2; exit 1' ERR

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'



HOME_TOOLS="$PREFIX/lib/termux-apk-make/toolz"
ANDROID_JAR="$HOME_TOOLS/android.jar"
ZIPALIGN="$HOME_TOOLS/zipalign"
APKSIGNER="$HOME_TOOLS/apksigner"

IFS=$'\n\t'

# Función de logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$BUILD_DIR/build.log"
}

# log "INFO" "Iniciando compilación..."
# log "ERROR" "Error al compilar código Java"

# Verificación post-compilación
verify_apk() {
    local apk_path="$1"

    log "INFO" "Verificando integridad del APK..."

    # Verificar que el APK no esté corrupto
    if ! unzip -t "$apk_path" > /dev/null 2>&1; then
        log "ERROR" "APK corrupto"
        return 1
    fi

    # Verificar que tenga classes.dex
    if ! unzip -l "$apk_path" | grep -q "classes.dex"; then
        log "ERROR" "APK sin classes.dex"
        return 1
    fi

    # Verificar firma
    if ! "$SCRIPT_DIR/toolz/$APKSIGNER" verify "$apk_path" > /dev/null 2>&1; then
        log "ERROR" "Firma inválida"
        return 1
    fi

    log "INFO" "APK verificado correctamente"
    return 0
}

setup_directories() {
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    PROJECT_DIR="${1:-}"
    
    # Validar directorio del proyecto
    if [ -z "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Debe especificar el directorio del proyecto${NC}"
        echo "Uso: $0 <directorio_del_proyecto>"
        exit 1
    fi

    # Obtener ruta absoluta
    if [[ "$PROJECT_DIR" != /* ]]; then
        PROJECT_DIR="$PWD/$PROJECT_DIR"
    fi
    cd $PROJECT_DIR
    # Verificar estructura básica de proyecto Android
    local required_dirs=("src" "res")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$PROJECT_DIR/$dir" ]; then
            echo -e "${RED}Error: El directorio no parece un proyecto Android válido (falta $dir/)${NC}"
            exit 1
        fi
    done

    # Verificar AndroidManifest.xml
    if [ ! -f "$PROJECT_DIR/AndroidManifest.xml" ]; then
        echo -e "${RED}Error: No se encontró AndroidManifest.xml${NC}"
        exit 1
    fi

    BUILD_DIR="$PROJECT_DIR/build"
    CLASSES_DIR="$BUILD_DIR/classes"
    mkdir -p "$CLASSES_DIR"
}

# Configurar entorno Java
setup_java_environment() {
    # Intentar detectar JAVA_HOME automáticamente
    if [ -z "${JAVA_HOME:-}" ]; then
        JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
        export JAVA_HOME
    fi

    export PATH="$JAVA_HOME/bin:$PATH"
    echo -e "${GREEN}Usando Java: $(javac -version 2>&1)${NC}"
}

compile_resources() {
    if [ -f "$PROJECT_DIR/res" ] ; then
        log "ERROR" "No esta /res"
    fi

    spin -c 220 -t "Compilando recursos con aapt2..." \
        --cmd  "aapt2 compile  --dir $PROJECT_DIR/res -o  $BUILD_DIR/resources.zip" -q --result \
        --error "Error al compilar recursos " --success "Compilado los recursos..." 
    }


link_resources() {
    spin -c 220  \
        -t  "Enlazando recursos con aapt2"  --cmd "aapt2 link  -I  $HOME_TOOLS/android.jar   --manifest  $PROJECT_DIR/AndroidManifest.xml --java $BUILD_DIR   -o  $BUILD_DIR/linked.apk $BUILD_DIR/resources.zip  --auto-add-overlay" -q --result --success "Enlazado los recursos..." --error "Error al enlazar recursos"   
    }

compile_java() {
    
    # Encontrar TODOS los archivos Java en src/
    local java_files=()
    while IFS= read -r -d $'\0' file; do
        java_files+=("$file")
    done < <(find src -name "*.java" -print0)
    
    if [ ${#java_files[@]} -eq 0 ]; then
        log  "ERROR" "${RED} No se encontraron archivos Java en src/${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Archivos Java encontrados:${NC}"
    printf '%s\n' "${java_files[@]}"
  
    # Buscar archivos R.java generados
    local r_java_files=()
    while IFS= read -r -d $'\0' file; do
        r_java_files+=("$file")
    done < <(find "$BUILD_DIR" -name "R.java" -print0 2>/dev/null)
    # Compilar todos los archivos Java juntos
    # Usar --release=9 para compatibilidad con Java 9+
    # O usar -source y -target para versiones específicas
    local  all_files=("${java_files[@]}" "${r_java_files[@]}") 
    local cmd="javac -d \"$CLASSES_DIR\" -cp \"$HOME_TOOLS/android.jar\""
    for file in "${all_files[@]}"; do
        cmd="$cmd \"$file\""
    done
 
    spin -c 220  -q  -t "Compilando código Java.." \
        --cmd "eval $cmd" \
        --result --error "Error al compilar código Java" --success "Compilado..." 
}

convert_to_dex() {
    local cmd

    cmd="d8 \
        --lib \"$HOME_TOOLS/android.jar\" \
        --output \"$BUILD_DIR\" \
        \$(find \"$CLASSES_DIR\" -type f -name '*.class')"

    spin -c 220\
        -t "Convirtiendo a DEX..." \
        --cmd "$cmd" \
        --success "DEX generado..." --result
}
#
# Empaquetar APK final
package_apk() {
    echo -e "${YELLOW}Empaquetando APK...${NC}"

    # Agregar classes.dex al APK
    (cd "$BUILD_DIR" && zip -u "linked.apk" "classes.dex") || {
        log  "ERROR" "Al a agregar classes.dex al APK"
        exit 1
    }

    # Agregar librerías nativas si existen
    if [ -d "$PROJECT_DIR/lib" ]; then #|| [ -d "$PROJECT_DIR/jni" ]; then
        echo -e "${YELLOW}Agregando librerías nativas...${NC}"
        (cd "$PROJECT_DIR" && zip -ur "$BUILD_DIR/linked.apk" "lib/" ) || {
            echo -e "${RED}Error al agregar librerías nativas${NC}"
            exit 1
        }
    fi

    # Alinear APK
    echo -e "${YELLOW}Alineando APK con zipalign...${NC}"
    "$HOME_TOOLS/zipalign" -f  -p 4 $BUILD_DIR/linked.apk $BUILD_DIR/aligned.apk || {
        echo -e "${RED}Error al alinear APK${NC}"
        exit 1
    }

    # Firmar APK
    echo -e "${YELLOW}Firmando APK...${NC}"
    "$HOME_TOOLS/apksigner" sign \
        --ks $HOME_TOOLS/key.keystore    \
        --min-sdk-version 21 \
        --ks-pass pass:password \
        --out "$BUILD_DIR/final.apk" \
        "$BUILD_DIR/aligned.apk" || {
        echo -e "${RED}Error al firmar APK${NC}"
        exit 1
    }
}

# Función principal
main() {
    setup_directories "$@"
    setup_java_environment

    # Limpiar compilaciones anteriores
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"

    compile_resources
    link_resources
    compile_java
    convert_to_dex
    package_apk

    echo -e "${GREEN}\n¡Compilación completada con éxito!${NC}"
    echo -e "APK final generado en: ${GREEN}$BUILD_DIR/final.apk${NC}"

    # Mostrar información básica del APK
    echo -e "\n${YELLOW}Información del APK:${NC}"
    aapt dump badging "$BUILD_DIR/final.apk" | grep -E "package:|launchable-activity:"
}

main "$@"

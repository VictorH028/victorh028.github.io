#!/bin/bash

set -euo pipefail
trap 'echo "Error en línea $LINENO. Código de salida: $?" >&2; exit 1' ERR

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SPIN_STYLE="dots"
SPIN_COLOR=220

HOME_TOOLS="$PREFIX/lib/termux-apk-make/toolz"
ANDROID_JAR="$HOME_TOOLS/android.jar"
ZIPALIGN="$HOME_TOOLS/zipalign"
APKSIGNER="$HOME_TOOLS/apksigner"

KS_PATH="$HOME_TOOLS/key.keystore"
MIN_SDK=21
IFS=$'\n\t'

usage() {
    cat <<EOF
Uso: $0 <comando> [opciones]

Comandos:
  <directorio>  Compila y firma APK desde proyecto Android
  <archivo.apk> Firma un APK existente

Ejemplos:
  termux-apk-make mi-app
  termux-apk-make app-unsigned.apk
EOF
    exit 0
}

parse_common_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --ks)
                KS_PATH="$2"
                shift 2
                ;;
            --ks-pass)
                KS_PASS="$2"
                shift 2
                ;;
            --ks-key-pass)
                KS_KEY_PASS="$2"
                shift 2
                ;;
            --ks-alias)
                KS_ALIAS="$2"
                shift 2
                ;;
            --min-sdk)
                MIN_SDK="$2"
                shift 2
                ;;
            -h|--help)
                usage
                ;;
            -*)
                echo -e "${RED}Opción desconocida: $1${NC}" >&2
                usage
                ;;
            *)
                break
                ;;
        esac
    done
}

log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Si BUILD_DIR está definido, guardamos en el log, de lo contrario solo imprimimos
    if [ -n "${BUILD_DIR:-}" ]; then
        echo "[$timestamp] [$level] $message" | tee -a "$BUILD_DIR/build.log"
    else
        echo "[$timestamp] [$level] $message"
    fi
}

verify_apk() {
    local apk_path="$1"
    log "INFO" "Verificando integridad del APK..."
    if ! unzip -t "$apk_path" > /dev/null 2>&1; then
        log "ERROR" "APK corrupto"
        return 1
    fi
    if ! unzip -l "$apk_path" | grep -q "classes.dex"; then
        log "ERROR" "APK sin classes.dex"
        return 1
    fi
    if ! "$HOME_TOOLS/apksigner" verify "$apk_path" > /dev/null 2>&1; then
        log "ERROR" "Firma inválida"
        return 1
    fi
    log "INFO" "APK verificado correctamente"
    return 0
}

sign_apk() {
    local input_apk="$1"
    local output_apk="${2:-${input_apk%.apk}-signed.apk}"

    echo -e "${YELLOW}Firmando APK: $input_apk -> $output_apk${NC}"

    if [ ! -f "$input_apk" ]; then
        echo -e "${RED}Error: APK no encontrado: $input_apk${NC}"
        exit 1
    fi

    "$HOME_TOOLS/apksigner" sign \
        --ks "$KS_PATH" \
        --min-sdk-version "$MIN_SDK" \
        --ks-pass pass:password \
        --out "$output_apk" \
        "$input_apk" || {
        echo -e "${RED}Error al firmar APK${NC}"
        exit 1
    }

    echo -e "${GREEN}APK firmado: $output_apk${NC}"
    verify_apk "$output_apk"
}

setup_directories() {
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    if [ -z "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Debe especificar el directorio del proyecto${NC}"
        exit 1
    fi

    if [[ "$PROJECT_DIR" != /* ]]; then
        PROJECT_DIR="$PWD/$PROJECT_DIR"
    fi
    cd "$PROJECT_DIR"

    local required_dirs=("src" "res")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$PROJECT_DIR/$dir" ]; then
            echo -e "${RED}Error: El directorio no parece un proyecto Android válido (falta $dir/)${NC}"
            exit 1
        fi
    done

    if [ ! -f "$PROJECT_DIR/AndroidManifest.xml" ]; then
        echo -e "${RED}Error: No se encontró AndroidManifest.xml${NC}"
        exit 1
    fi

    BUILD_DIR="$PROJECT_DIR/build"
    CLASSES_DIR="$BUILD_DIR/classes"
    mkdir -p "$CLASSES_DIR"
}

setup_java_environment() {
    if [ -z "${JAVA_HOME:-}" ]; then
        JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
        export JAVA_HOME
    fi
    export PATH="$JAVA_HOME/bin:$PATH"
    echo -e "${GREEN}Usando Java: $(javac -version 2>&1)${NC}"
}

compile_resources() {
    # Corregido: verificar si NO es un directorio
    if [ ! -d "$PROJECT_DIR/res" ]; then
        log "ERROR" "No esta el directorio /res"
        exit 1
    fi
    spin -s "$SPIN_STYLE" -c "$SPIN_COLOR" -t "Compilando recursos con aapt2..." \
        --cmd "aapt2 compile --dir $PROJECT_DIR/res -o $BUILD_DIR/resources.zip" -q --result \
        --error "Error al compilar recursos" --success "Compilado los recursos..."
}

link_resources() {
    spin -s "$SPIN_STYLE" -c "$SPIN_COLOR" \
        -t "Enlazando recursos con aapt2" --cmd "aapt2 link -I $HOME_TOOLS/android.jar --manifest $PROJECT_DIR/AndroidManifest.xml --java $BUILD_DIR -o $BUILD_DIR/linked.apk $BUILD_DIR/resources.zip --auto-add-overlay" -q --result --success "Enlazado los recursos..." --error "Error al enlazar recursos"
}

compile_java() {
    local java_files=()
    while IFS= read -r -d $'\0' file; do
        java_files+=("$file")
    done < <(find src -name "*.java" -print0)

    if [ ${#java_files[@]} -eq 0 ]; then
        log "ERROR" "${RED} No se encontraron archivos Java en src/${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Archivos Java encontrados:${NC}"
    printf '%s\n' "${java_files[@]}"

    local r_java_files=()
    while IFS= read -r -d $'\0' file; do
        r_java_files+=("$file")
    done < <(find "$BUILD_DIR" -name "R.java" -print0 2>/dev/null)

    local all_files=("${java_files[@]}" "${r_java_files[@]}")
    local cmd="javac -d \"$CLASSES_DIR\" -cp \"$HOME_TOOLS/android.jar\""
    for file in "${all_files[@]}"; do
        cmd="$cmd \"$file\""
    done

    spin -s "$SPIN_STYLE" -c "$SPIN_COLOR" -q -t "Compilando código Java.." \
        --cmd "eval $cmd" \
        --result --error "Error al compilar código Java" --success "Compilado..."
}

convert_to_dex() {
    local cmd="d8 --lib \"$HOME_TOOLS/android.jar\" --output \"$BUILD_DIR\" \$(find \"$CLASSES_DIR\" -type f -name '*.class')"
    spin -s "$SPIN_STYLE" -c "$SPIN_COLOR" -t "Convirtiendo a DEX..." --cmd "$cmd" --success "DEX generado..." --result
}

package_apk() {
    echo -e "${YELLOW}Empaquetando APK...${NC}"
    (cd "$BUILD_DIR" && zip -u "linked.apk" "classes.dex") || {
        log "ERROR" "Al agregar classes.dex al APK"
        exit 1
    }
    if [ -d "$PROJECT_DIR/lib" ]; then
        echo -e "${YELLOW}Agregando librerías nativas...${NC}"
        (cd "$PROJECT_DIR" && zip -ur "$BUILD_DIR/linked.apk" "lib/" ) || {
            echo -e "${RED}Error al agregar librerías nativas${NC}"
            exit 1
        }
    fi
    echo -e "${YELLOW}Alineando APK con zipalign...${NC}"
    "$HOME_TOOLS/zipalign" -f -p 4 "$BUILD_DIR/linked.apk" "$BUILD_DIR/aligned.apk" || {
        echo -e "${RED}Error al alinear APK${NC}"
        exit 1
    }

    echo -e "${YELLOW}Firmando APK...${NC}"
    "$HOME_TOOLS/apksigner" sign \
        --ks "$KS_PATH" \
        --min-sdk-version "$MIN_SDK" \
        --ks-pass pass:password \
        --out "$BUILD_DIR/final.apk" \
        "$BUILD_DIR/aligned.apk" || {
        echo -e "${RED}Error al firmar APK${NC}"
        exit 1
    }
}

cmd_build_apk() {
    local project_dir="${1:-}"
    if [ -z "$project_dir" ] || [[ "$project_dir" == "-h" ]] || [[ "$project_dir" == "--help" ]]; then
        usage
    fi
    PROJECT_DIR="$project_dir"
    shift
    parse_common_args "$@"

    setup_directories
    setup_java_environment
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    compile_resources
    link_resources
    compile_java
    convert_to_dex
    package_apk

    echo -e "${GREEN}\n¡Compilación completada con éxito!${NC}"
    echo -e "APK final generado en: ${GREEN}$BUILD_DIR/final.apk${NC}"
    echo -e "\n${YELLOW}Información del APK:${NC}"
    aapt dump badging "$BUILD_DIR/final.apk" | grep -E "package:|launchable-activity:"
}

cmd_sign() {
    local input_apk="${1:-}"
    if [ -z "$input_apk" ] || [[ "$input_apk" == "-h" ]] || [[ "$input_apk" == "--help" ]]; then
        usage
    fi
    shift
    parse_common_args "$@"

    if [[ "$input_apk" != /* ]]; then
        input_apk="$PWD/$input_apk"
    fi

    sign_apk "$input_apk"
}

main() {
    if [ $# -eq 0 ]; then
        usage
        exit 1
    fi

    local TARGET="$1"

    if [ -d "$TARGET" ]; then
        cmd_build_apk "$@"

    elif [[ "$TARGET" == *.APK || "$TARGET" == *.apk ]]; then
        cmd_sign "$@"

    elif [[ "$TARGET" == "-h" || "$TARGET" == "--help" || "$TARGET" == "help" ]]; then
        usage
        exit 0

    else
        echo -e "${RED}Error: Debes pasar un directorio o un archivo que termine en .APK${NC}"
        usage
        exit 1
    fi
}

main "$@"


#!/usr/bin/env bash
set -uo pipefail

SCRIPT="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || printf '%s' "${BASH_SOURCE[0]}")"
SYSROOT="$(cd "$(dirname "$SCRIPT")" && pwd)"
CACHE="${DEEPLIB_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/deepLib}"
SUITE="${DEEPLIB_SUITE:-bookworm}"
ARCH="amd64"
JOBS="${DEEPLIB_JOBS:-4}"
FORZAR="${DEEPLIB_FORCE:-0}"
LIMPIAR=1
SOLO_LIMPIAR=0

PAQUETES=(
    "libsystemd0"
    "libbsd0"
    "libdeflate0"
    "libjbig0"
    "libpng16-16"
    "liblerc4"
    "liblzma5"
    "libffi8"
    "libexpat1"
    "libwayland-server0"
    "libdbus-1-3"
    "libudev1"
    "libinput10"
    "libevdev2"
    "libmtdev1"
    "libglib2.0-0"
    "libfreetype6"
    "libfontconfig1"
    "libharfbuzz0b"
    "libzstd1"
    "libbz2-1.0"
    "libxrender1"
    "libxinerama1"
    "libxcomposite1"
    "libxkbcommon-x11-0"
    "libvulkan1"
    "libsndfile1"
    "libasyncns0"
    "libflac12"
    "libvorbisenc2"
    "libopus0"
    "libmpg123-0"
    "libmp3lame0"
    "libsndio7.0"
    "libwebp7"
    "libtiff6"
    "libdecor-0-0"
    "libxkbcommon0"
    "xkb-data"
    "libwayland-cursor0"
    "libwayland-client0"
    "libwayland-egl1"
    "libgbm1"
    "libdrm2"
    "libxss1"
    "libxrandr2"
    "libxfixes3"
    "libxi6"
    "libxcursor1"
    "libsamplerate0"
    "libpulse0"
    "libasound2"
    "libasound2-data"
    "libc6"
    "libstdc++6"
    "libgcc-s1"
    "zlib1g"
    "libxcb1"
    "libxau6"
    "libxdmcp6"
    "libx11-6"
    "libxext6"
    "libx11-xcb1"
    "libgl1"
    "libglvnd0"
    "libglx0"
    "libglapi-mesa"
    "libglx-mesa0"
    "libgl1-mesa-dri"
    "libegl1"
    "libsdl2-2.0-0"
    "libsdl2-image-2.0-0"
    "libjpeg62-turbo"
    "libogg0"
    "libvorbis0a"
    "libvorbisfile3"
    "libopenal1"
    "libcurl4"
    "libssl3"
    "libnghttp2-14"
    "libidn2-0"
    "libpsl5"
    "libbrotli1"
)

msg() {
    printf '%s\n' "$*" >&2
}

obtener_url() {
    local pkg="$1" pagina
    pagina="$(curl -fsSL --retry 2 --connect-timeout 20 \
        "https://packages.debian.org/${SUITE}/${ARCH}/${pkg}/download")" || return 1
    printf '%s\n' "$pagina" |
        grep -oE "https?://[^\"']+/pool/[^\"']+\.deb" |
        head -n 1
}

extraer() {
    local deb="$1" salida rc enlaces dest target ddir tdir
    salida="$(dpkg-deb -x "$deb" "$SYSROOT" 2>&1)"
    rc=$?

    if [ "$rc" -eq 0 ]; then
        return 0
    fi

    if printf '%s\n' "$salida" | grep -q 'hard link'; then
        enlaces="$(dpkg-deb -c "$deb" |
            awk '/ link to / {
                for (i = 1; i <= NF; i++)
                    if ($i == "link" && $(i+1) == "to")
                        print $(i-1), $(i+2)
            }')"
        while read -r dest target; do
            [ -n "$dest" ] || continue
            ddir="$(dirname "${dest#./}")"
            tdir="$(dirname "${target#./}")"
            if [ "$ddir" = "$tdir" ]; then
                ln -sfn "$(basename "$target")" "$SYSROOT/${dest#./}" ||
                    return "$rc"
            fi
        done <<< "$enlaces"
        msg "  ! enlaces duros convertidos a symlinks"
        return 0
    fi

    printf '%s\n' "$salida" >&2
    return "$rc"
}

procesar() {
    local pkg="$1"
    local deb="$CACHE/$pkg.deb"
    local marca="$CACHE/$pkg.installed"
    local fallo="$CACHE/$pkg.failed"

    if [ "$FORZAR" -eq 0 ] && [ -f "$marca" ]; then
        msg "  = $pkg (ya instalado)"
        return 0
    fi

    if [ -s "$deb" ]; then
        msg "  = $pkg (usando cache)"
    else
        local url
        url="$(obtener_url "$pkg")"
        if [ -z "$url" ]; then
            msg "  ! $pkg: no se encontro el .deb"
            touch "$fallo"
            return 1
        fi
        msg "  + $pkg: $(basename "$url")"
        if ! curl -fsSL --retry 3 --retry-delay 2 --connect-timeout 20 \
            -o "$deb.part" "$url"; then
            rm -f "$deb.part"
            msg "  ! $pkg: fallo la descarga"
            touch "$fallo"
            return 1
        fi
        mv -f "$deb.part" "$deb"
    fi

    if extraer "$deb"; then
        touch "$marca"
        rm -f "$fallo"
        msg "  ok $pkg"
    else
        msg "  ! $pkg: fallo la extraccion"
        touch "$fallo"
        return 1
    fi
}

preparar_marcas() {
    local pkg
    for pkg in "${PAQUETES[@]}"; do
        if [ ! -f "$CACHE/$pkg.installed" ] &&
            [ -d "$SYSROOT/usr/share/doc/$pkg" ]; then
            touch "$CACHE/$pkg.installed"
        fi
    done
}

limpiar() {
    msg "== Limpiando archivos innecesarios para qemu =="
    rm -rf "$SYSROOT"/usr/share/doc/* \
        "$SYSROOT"/usr/share/man/* \
        "$SYSROOT"/usr/share/info/* \
        "$SYSROOT"/usr/share/lintian/* \
        "$SYSROOT"/usr/share/bug/* \
        "$SYSROOT"/usr/share/gdb \
        "$SYSROOT"/usr/share/gcc \
        "$SYSROOT"/usr/share/bash-completion \
        "$SYSROOT"/usr/share/perl5 \
        "$SYSROOT"/usr/share/perl \
        "$SYSROOT"/usr/share/i18n \
        "$SYSROOT"/usr/share/common-licenses \
        "$SYSROOT"/usr/lib/apt \
        "$SYSROOT"/usr/share/keyrings
    find "$SYSROOT/usr/share/locale" -mindepth 1 -maxdepth 1 -type d \
        -exec rm -rf {} + 2>/dev/null || true
    rm -rf "$SYSROOT"/var/lib/apt/lists/* \
        "$SYSROOT"/var/cache/apt/archives/*.deb \
        "$SYSROOT"/var/cache/apt/archives/partial/* \
        "$SYSROOT"/var/lib/dpkg/updates/* \
        "$SYSROOT"/var/log/*
    find "$SYSROOT" -maxdepth 1 -type f \
        \( -name '*.deb' -o -name '*.deb.part' \) -delete
    find "$SYSROOT/lib" "$SYSROOT/usr/lib" -type f \
        \( -name '*.a' -o -name '*.la' -o -name '*.o' \) -delete 2>/dev/null
    msg "   limpieza terminada."
}

main() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --no-clean) LIMPIAR=0 ;;
            --force) FORZAR=1 ;;
            --jobs) JOBS="${2:-$JOBS}"; shift ;;
            --clean-only) SOLO_LIMPIAR=1 ;;
            -h|--help)
                printf '%s\n' \
                    "Uso: bash deepLib.sh [opciones]" \
                    "  --force       vuelve a procesar todo" \
                    "  --jobs N      descargas en paralelo (defecto: $JOBS)" \
                    "  --no-clean    no borra archivos innecesarios" \
                    "  --clean-only  solo limpia el sysroot"
                exit 0
                ;;
            *) msg "Opcion desconocida: $1"; exit 2 ;;
        esac
        shift
    done

    for cmd in curl dpkg-deb; do
        command -v "$cmd" >/dev/null 2>&1 || {
            msg "Falta el comando: $cmd"
            exit 1
        }
    done

    mkdir -p "$CACHE"
    msg "== Sysroot: $SYSROOT"
    msg "== Cache:   $CACHE"

    if [ "$SOLO_LIMPIAR" -eq 0 ]; then
        preparar_marcas
        export DEEPLIB_FORCE="$FORZAR"

        local pkg cmd lineas=()
        for pkg in "${PAQUETES[@]}"; do
            lineas+=("bash \"$SCRIPT\" --process \"$SYSROOT\" \"$CACHE\" \"$pkg\"")
        done

        if command -v spin >/dev/null 2>&1; then
            cmd="$(printf '%s\n' "${lineas[@]}")"
            spin --cmd "$cmd" -j "$JOBS" -q -t "Preparando librerias" \
                -s "Librerias listas" -e "Hubo errores" --result
        else
            for pkg in "${PAQUETES[@]}"; do
                procesar "$pkg"
            done
        fi

        local errores=0
        for pkg in "${PAQUETES[@]}"; do
            if [ -f "$CACHE/$pkg.failed" ]; then
                msg "  ! pendiente: $pkg"
                errores=$((errores + 1))
            fi
        done
        if [ "$errores" -gt 0 ]; then
            msg "== $errores paquete(s) con error; vuelve a ejecutar el script."
        fi
    fi

    if [ "$LIMPIAR" -eq 1 ]; then
        limpiar
    fi

    msg "== Proceso finalizado =="
}

if [ "${1:-}" = "--process" ]; then
    SYSROOT="$2"
    CACHE="$3"
    mkdir -p "$CACHE"
    procesar "$4"
    exit $?
fi

main "$@"

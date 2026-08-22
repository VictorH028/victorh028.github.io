#!/data/data/com.termux/files/usr/bin/bash

for deb in *.deb; do
    if file "$deb" | grep -q "data compression zst"; then
        echo "🔧 Convirtiendo: $deb"
        
        # Crear directorio temporal
        mkdir -p temp_convert
        cd temp_convert
        
        # Extraer archivos del .deb
        ar x "../$deb"
        
        # Convertir data.tar.zst a data.tar.xz
        if [ -f "data.tar.zst" ]; then
            zstd -d data.tar.zst -o data.tar
            xz -z data.tar
            mv data.tar.xz data.tar.xz
        fi
        
        # También convertir control si es zst
        if [ -f "control.tar.zst" ]; then
            zstd -d control.tar.zst -o control.tar
            xz -z control.tar
            mv control.tar.xz control.tar.xz
        fi
        
        # Reconstruir el .deb
        ar rcs "../${deb%.deb}_fixed.deb" debian-binary control.tar.xz data.tar.xz
        
        cd ..
        rm -rf temp_convert
        
        # Reemplazar original
        mv "${deb%.deb}_fixed.deb" "$deb"
        echo "✅ $deb convertido exitosamente"
    fi
done

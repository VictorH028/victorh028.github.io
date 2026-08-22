# Script para convertir todos los .deb problemáticos
for deb in *.deb; do
    # Verificar si usa zstd
    if file "$deb" | grep -q "control.tar.zst"; then
        echo "Convirtiendo $deb..."
        
        mkdir -p temp_convert
        cd temp_convert
        ar x "../$deb"
        
        # Descomprimir control
        zstd -d control.tar.zst -o control.tar
        
        # Reemplazar con xz
        xz -z control.tar
        
        # Reconstruir
        ar rcs "../${deb%.deb}_fixed.deb" debian-binary control.tar.xz data.tar.zst
        cd ..
        rm -rf temp_convert
        
        mv "${deb%.deb}_fixed.deb" "$deb"
    fi
done

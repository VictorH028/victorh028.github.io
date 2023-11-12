# 📦 Paguetes para termux

Este proyecto tiene como propósito ofrecer acceso fácil y rápido a la instalación
de herramientas y/o frameworks proporcionados por el laboratorio de ciberseguridad 
y pentesting i-Haklab, para el sistema operativo Android bajo la aplicación Termux.


# Cómo llegar ..
Instale el paquete wget:
```bash
apt install wget
```
Crear directorio:

```bash
mkdir -p $PREFIX/etc/apt/sources.list.d
```
Descargar archivo fuente:

```bash
wget https://  -O $PREFIX/etc/apt/sources.list.d/demon-packge-packages.list
```

Actualizar termux:
```bash
apt update && apt upgrade 
```
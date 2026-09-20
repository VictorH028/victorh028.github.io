---
layout: single
title: "demon-packages"
date: 2026-09-20
classes: wide
categories:

- termux
- packages
  tags:
- termux
- apt
- packages
- tools
  header:
  teaser_home_page: true
---

# Demon Packages

Repositorio de paquetes y herramientas adaptadas para Termux.

Este repositorio permite instalar mis herramientas directamente mediante el gestor de paquetes "apt", sin necesidad de descargar manualmente cada proyecto.

---

# 🚀 Instalación rápida

Puedes configurar el repositorio con estos comandos.

1. Importar la clave del repositorio

```
wget -O- https://raw.githubusercontent.com/VictorH028/victorh028.github.io/refs/heads/main/demon-packages/demon-packages-key.asc | gpg --dearmor > $PREFIX/etc/apt/trusted.gpg.d/demon.gpg
```

2. Añadir Demon Packages a APT

```
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/demon.gpg arch=all] https://victorh028.github.io/demon-packages stable extras"  > $PREFIX/etc/apt/sources.list.d/demon-packages.list
```

3. Actualizar los repositorios

```
apt update 
```

Si todo está correctamente, Termux podrá consultar los paquetes disponibles en Demon Packages.

---

# 📦 Instalar paquetes

Una vez añadido el repositorio, puedes utilizar "apt" normalmente.

apt install NOMBRE_DEL_PAQUETE

Por ejemplo:

apt install spin

«Sustituye "spin" por el nombre del paquete que quieras instalar.»

---

# 🔎 Buscar paquetes

Puedes buscar herramientas disponibles utilizando:

```
apt search <herramienta> 
```

---

# 🔄 Actualizar

Para actualizar la información de los repositorios:

```
apt update 
```

Para actualizar los paquetes instalados:

```
apt upgrade 
```

O ambas operaciones:

```
apt update && apt upgrade
```
---

# 🗑️ Desinstalar

Para eliminar una herramienta:

```
apt remove NOMBRE_DEL_PAQUETE
```

Por ejemplo:

```
apt remove spin
```

---

# 🔐 Firma y seguridad

Demon Packages utiliza una clave GPG para verificar la autenticidad de los metadatos del repositorio.

La clave se instala en:

```
$PREFIX/etc/apt/trusted.gpg.d/demon.gpg
```

Y el repositorio se configura utilizando:

```
signed-by=$PREFIX/etc/apt/trusted.gpg.d/demon.gpg
```

Esto permite que APT utilice específicamente esta clave para verificar el repositorio.

---

# 🛠️ Herramientas disponibles

Aquí iré agregando las herramientas adaptadas o empaquetadas específicamente para Termux.

Paquete| Descripción
"spin"| Herramienta CLI para ejecutar comandos mostrando estados y resultados
"termux-apk-make"| Un compilador de apk simple...

«Esta lista se actualizará a medida que se publiquen nuevos paquetes.»

---

# 📋 Comprobar la configuración

Puedes comprobar que el repositorio está configurado correctamente ejecutando:

```
apt update 
```

También puedes comprobar que el archivo del repositorio existe:

```
cat $PREFIX/etc/apt/sources.list.d/demon-packages.list
```

Deberías encontrar una línea similar a:

```
deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/demon.gpg arch=all] https://victorh028.github.io/demon-packages stable extras
```

---

# ❌ Problemas frecuentes

"apt update" no encuentra el repositorio

Comprueba que el archivo existe:

```
ls $PREFIX/etc/apt/sources.list.d/
```

Y revisa su contenido:

```
cat $PREFIX/etc/apt/sources.list.d/demon-packages.list
```

---

*Error relacionado con la clave GPG*

Vuelve a instalar la clave:

```
wget -O- https://raw.githubusercontent.com/VictorH028/victorh028.github.io/refs/heads/main/demon-packages/demon-packages-key.asc   | gpg --dearmor > $PREFIX/etc/apt/trusted.gpg.d/demon.gpg
```

Después:

```
apt update
```

---

> [!WARNING]
>  Si estas usando [i-haklab](url) el confiigura todo esto por nosotros y de repetir la configuracion puede causar conflictos.


# 📚 Para desarrolladores

La estructura del repositorio permite publicar paquetes para Termux mediante un repositorio APT.

La firma del repositorio se realiza mediante GPG y los metadatos "Release", "InRelease" y "Release.gpg".

Estos pasos son necesarios para mantener/publicar el repositorio, pero no son necesarios para los usuarios que solamente quieren instalar las herramientas.

---

# 🔗 Proyecto

GitHub:
"VictorH028/victorh028.github.io" (https://github.com/VictorH028/victorh028.github.io)

Repositorio APT:
https://victorh028.github.io/demon-packages/

---

# 💬 Soporte

Si encuentras un problema con alguno de los paquetes.

- Telegram @demonr_rip


{% if page.comments %}
<div id="disqus_thread"></div>
<script>
    (function() { // DON'T EDIT BELOW THIS LINE
    var d = document, s = d.createElement('script');
    s.src = 'https://blok-termux.disqus.com/embed.js';
    s.setAttribute('data-timestamp', +new Date());
    (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
{% endif %}



---
#layout: default
comments: true
layout: single
title: desktop
date: 2023-10-10
classes: wide
header:
  teaser: /assets/images/
  teaser_home_page: true
categories:
  - notas 
tags:
  - Linux
  - tips
---


Para mostrar tu aplicaciones en el menu  de Linux, puedes crear un archivo `.desktop`. Estos archivos se utilizan para definir las propiedades de una aplicación y cómo se mostrará en el menú de aplicaciones. A continuación, te proporciono un ejemplo de cómo crear un archivo `.desktop`.:

1. Abre un editor de texto y crea un archivo llamado `mi_programa.desktop` con el siguiente contenido:

```desktop
[Desktop Entry]
Type=Application
Name=Mi Programa
Exec=/ruta/a/tu/programa
Icon=/ruta/a/una/imagen/icono.png
Terminal=false
Categories=Development;
````

Asegúrate de reemplazar `/ruta/a/tu/programa` con la ruta completa de la aplicación que deseas ejecutar y `/ruta/a/una/imagen/icono.png` con la ruta completa de la imagen de icono que deseas utilizar para tu aplicación.

2. Guarda el archivo `mi_programa.desktop` en el directorio `~/.local/share/applications` para que esté disponible solo para tu usuario, o en `/usr/share/applications` si deseas que esté disponible para todos los usuarios en el sistema.

3. Asegúrate de que el archivo `.desktop` tenga permisos de ejecución. Puedes hacerlo con el siguiente comando en la terminal:

```
chmod +x /ruta/a/tu/archivo.desktop
```

4. Después de hacer esto, deberías ver "Mi Probgrama" en el menú de aplicaciones de tu entorno de escritorio Linux, y al hacer clic en él, se ejecutará tu programa.

Nota: Asegúrate de que el archivo `.desktop` tenga los permisos adecuados y que la ruta a tu programa y al icono sean correctas para que funcione correctamente. El icono debe ser una imagen en formato PNG de 48x48 píxeles (aunque puedes ajustar el tamaño según tus necesidades).

Este es un ejemplo simple de cómo crear un acceso directo en el menú de aplicaciones en Linux para tu programa en C++. Puedes personalizar el archivo `.desktop` según tus necesidades específicas.




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


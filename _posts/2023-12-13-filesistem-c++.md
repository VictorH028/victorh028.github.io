---
#layout: default
comments: true
layout: single
title: Notas de git 
date: 2023-04-20
classes: wide
header:
  teaser: /assets/images/
  teaser_home_page: true
categories:
  - Programacion
  - notas 
tags:
  - termux
---


# **Filesystem**


**Definiciones para toda la `bibloeca`** 
- `file`:  Un objeto del sistema de archivos que contiene datos, en el que se puede escribir, leer o ambas cosas. Los archivos tienen nombres, atributos, uno de los cuales es el tipo de archivo.

- `directory`: Un archivo que actúa como contenedor de entradas de directorio, que identifican otros archivos (algunos de los cuales pueden ser otros directorios anidados). Cuando se habla de un archivo en particular, el directorio en el que aparece como entrada es su directorio principal . El directorio principal se puede representar mediante el nombre de ruta relativo. `"..."`.

- `regular file`:  Una entrada de directorio que asocia un nombre con un archivo existente (es decir, un enlace físico ). Si se admiten varios enlaces físicos, el archivo se elimina después de eliminar el último enlace físico.

- `symbolic link`: Una entrada de directorio que asocia un nombre con una ruta, que puede existir o no.

- `other special file types`: bloque , carácter , fifo , socket .

- `file name`: Una cadena de caracteres que nombra un archivo. Los caracteres permitidos, la distinción entre mayúsculas y minúsculas, la longitud máxima y los nombres no permitidos están definidos por la implementación. Nombres `"."` `(punto)` y `"..."``(punto-punto)` tienen un significado especial a nivel de biblioteca.

- `path`: Secuencia de elementos que identifica un archivo. Comienza con un nombre raíz opcional (p. ej.`"C:"o"//servidor"` en Windows), seguido de un directorio raíz opcional (p. ej.`"/"` en Unix), seguido de una secuencia de cero o más nombres de archivos (todos menos el último deben ser directorios o enlaces a directorios). El formato nativo (por ejemplo, qué caracteres se utilizan como separadores) y la codificación de caracteres de la representación de cadena de una ruta (el nombre de la ruta ) están definidos por la implementación; esta biblioteca proporciona una representación portátil de las rutas.

- `absolute path`: Una ruta que identifica inequívocamente la ubicación de un archivo.

- `canonical pat`:  Una ruta absoluta que no incluye enlaces simbólicos,"."o"..."elementos

- `relative path`: Una ruta que identifica la ubicación de un archivo en relación con alguna ubicación en el sistema de archivos. Los nombres de ruta especiales"."(punto, "directorio actual") y"..."(punto-punto, "directorio principal") son rutas relativas.

# **classes**

- `path`: Representa una ruta

- `filesystem_error`: Una excepción lanzada en errores del sistema de archivos

- `directory_entry`: Una entrada de directorio 

- `directory_iterator`: un iterador del contenido del directorio

- `recursive_directory_iterator`:  un iterador del contenido de un directorio y sus subdirectorios

- `file_status`: Representa el tipo de archivo y los permisos 

- `space_info`: El tipo de archivo (`enum`)

- `file_type`: Identifica los permisos del sistema de archivos (`enum`)

- `perms`: Especifica la semántica de las operaciones de permisos (`enum`)

- `perm_options`: Especifica la semántica de las operaciones de permisos (`enum`)

- `copy_options`: Especifica la semántica de las operaciones de copia(`enum` )

- `directory_options`: Opciones para iterar el contenido del directorio (`enum`)

- `file_time_type`: Representa los valores de tiempo del archivo (`enum` )

# **Funciones de no miembros**






{% if page.comments %}
<div id="disqus_thread"></div>
<script>
    (function() { // don't edit below this line
    var d = document, s = d.createelement('script');
    s.src = 'https://blok-termux.disqus.com/embed.js';
    s.setattribute('data-timestamp', +new date());
    (d.head || d.body).appendchild(s);
    })();
</script>
<noscript>please enable javascript to view the <a href="https://disqus.com/?ref_noscript">comments powered by disqus.</a></noscript>
{% endif %}


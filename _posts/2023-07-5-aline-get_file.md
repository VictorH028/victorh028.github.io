---
comments: true
layout: single
title: Como grabar archivos locales en alpine 
date: 2023-07-5
classes: wide
header:
  teaser: /assets/images/
  teaser_home_page: true
categories:
  - termux
tags:
  - alpine
---

En esta oportunidad vamos a estar viendo como pasar un archivio que tenemos en termux a alpine:

# Informacion 
Un servidor es un conjunto de computadoras capaces de atender las peticiones de un cliente y devolverle una respuesta en concordancia el cual podemos crear condiversos comandos como (nc,python,localtunnel,php,..etc) el cual estare utilisando *php*

# intalacion
`apt install php`

La lista de opciones de línea de comandos proporcionada por el binario de PHP se puede consultar en cualquier momento ejecutando PHP con el argumento -h
el cual estaremos utilizando la opcion **-S** que ejecutar con servidor web incorporado.

**Nota:** Hay que tener en cuenta la formato de una URL que  esta compuesto por varias partes: Protocolo, Dominio, Extensión, Recurso y Parámetros. 

[[imagen]]

Ya teniendo el binario _php_ instalado pasamos a ejecutar lo sigiente:

```sh 
php 127.0.0.1:8080  
```

El cual ejecurata el servidor pero no nos dejara escribir nada mas para evitar eso podemos usar _CTRL-z_ para que pase a 2 plano o agregar al final de el comando lo sigiente ** 2>&1 &** para tener el mismo resultado 

```sh
php 127.0.0.1:8080 2>&1 &
```
Depues de esto pasamos a ejecutar el sigiente comando `ssh -R 80:localhost:8080 nokey@localhost.run` que permite a los desarrolladores exponer un servidor de desarrollo local a Internet con un esfuerzo mínimo. 

[[imagen]]

Con el link que nos otorgaron lo copiamos y cresmos una nueva secion
con _CTRL-ALT-c_ para corer alpine

# En alpine

Intalamos  a **wget**

```sh
apk add  wget
```

El comando wget es una herramienta desarrollada por el proyecto GNU para descargar archivos de la web. _wget_ le permite recuperar contenido y archivos de servidores web utilizando una interfaz de línea de comandos.

```sh
wget URL  
```


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





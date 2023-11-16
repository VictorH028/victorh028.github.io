---
comments: true
layout: single
title: Como intalar localtunnel
date: 2023-04-17
classes: wide
header:
  teaser: /assets/images/localtunnel/icon-localtunnel.png
  teaser_home_page: true
categories:
  - termux
tags:
  - error
  - termux
---


En esta oportunidad vamos a aprender como  instalar `localtunel` en nuestra terminal sin errores  

# Instalacion

## Paso 1: actualizar paquetes

Ejecute el siguiente comando

```bash
apt update && apt upgrade -y
```
## Paso 2: Instalar termux-api

Ahora debe asegurarse de que termux tenga acceso a las funciones de hardware de Android y Chrome. Ejecute el siguiente comando.

```bash
apt install termux-api
```

## Paso 3: Install paquete de nodejs

Para su intalacion ejecutar

```bash
apt  install nodejs
``` 

## Paso 4: Instalar localtunel

```bash
npm install -g localtunnel
```

Despues de que finalice la instalacion tendremos un error la ejecutal el comado `lt` que seria la 
abreviatura de `localtunel` mostrando por pantalla lo siguente 

```shell
/data/data/com.termux/files/usr/lib/node_modules/localtunnel/node_modules/openurl/openurl.js:16
        throw new Error('Unsupported platform: ' + process.platform);
        ^

Error: Unsupported platform: android
    at Object.<anonymous> (/data/data/com.termux/files/usr/lib/node_modules/localtunnel/node_modules/openurl/openurl.js:16:15)
    at Module._compile (node:internal/modules/cjs/loader:1275:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1329:10)
    at Module.load (node:internal/modules/cjs/loader:1133:32)
    at Module._load (node:internal/modules/cjs/loader:972:12)
    at Module.require (node:internal/modules/cjs/loader:1157:19)
    at require (node:internal/modules/helpers:119:18)
    at Object.<anonymous> (/data/data/com.termux/files/usr/lib/node_modules/localtunnel/bin/lt.js:4:17)
    at Module._compile (node:internal/modules/cjs/loader:1275:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1329:10)

Node.js v19.6.1
```

Para solucionar lo siguente procederemos a untilizar nuestro editor de texto faborito y editaremos el siguiente archivo 

```bash
nvim $PREFIX/lib/node_modules/localtunnel/node_modules/openurl/openurl.js
```

Nos pocisionaremos en la linea numero `14` gregamos la siguente fracmento de codigo despues de el 
ultimo `break` 

```bash
case 'android':
    command = 'termux';
    break;
```
## Resultado final

```bash
    5 switch(process.platform) {
    6     case 'darwin':
    7         command = 'open';                      
    8         break;
    9     case 'win32':
   10         command = 'explorer.exe';
   11         break;
   12     case 'linux':
   13         command = 'xdg-open';
   14         break;
   15     case 'android':
   16         command = 'termux';                   
   17         break;
   18     default:
   19         throw new Error('Unsupported platform: ' + process.platform);
   20 }
```
# usar
Suponiendo que su servidor local se está ejecutando en el puerto 8000, simplemente use el ltcomando para iniciar el túnel.

```bash
lt --port 8000
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



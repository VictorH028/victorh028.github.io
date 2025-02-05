# Mis demonis en un solo lugar 


> [!WARNING]
> 


> [!NOTE]
> Mucho del mis imsobnios  vine de  la comunidad de ``@ivam3`` y sus subcriptores 


# Android Ingenieria Inversa 

# Programacion lenguajes 

- C++  : [[ 1 ]](https://www.learncpp.com) - [[ 2 ]](https://en.cppreference.com)
- Java : [[ 1 ]](https://www.homeandlearn.co.uk/java/java.html) - [[ 2 ]](https://www.codecademy.com/learn/learn-java) - [[ 3 ]](https://www.tutorialspoint.com/java/index.htm) - [[ 4 ]](https://www.youtube.com/watch?v=eIrMbAQSU34&t=6s)
- Kotlin : [[ 1 ]](https://developer.android.com/kotlin) - [[ 2 ]](https://kotlinlang.org/docs/home.html)
- XML : [[ 1 ]](https://www.w3schools.com/xml/) - [[ 2 ]](https://www.tutorialspoint.com/xml/index.htm)
- Smali : [[ 1 ]](https://github.com/JesusFreke/smali) - [[ 2 ]](https://source.android.com/devices/tech/dalvik/dalvik-bytecode) - [[ 3 ]](https://programmer.help/blogs/smali-introduction-manual.html) - [[ 4 ]](https://forum.xda-developers.com/t/guide-smali-coding-guide-for-beginners.2193735/)
- Assembly :  [[ 1 ]](https://www.tutorialspoint.com/assembly_programming/index.htm) - [[ 2 ]](https://cs.lmu.edu/~ray/notes/nasmtutorial/) - [[ 3 ]](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html) - [[ 4 ]](http://www.egr.unlv.edu/~ed/assembly64.pdf)


# Redes

- ISO model
- TCP/IP
- DNC 
- HTTP
- SSL/TLS
- Proxy 

# Criptografia 

- Encryption : 
- Hashing :
- MAC :
- RSA :
- AES :

# Diseño y arquitectura de Android

- Núcleo de Linux: [ 1 ]
- HAL
- Biblioteca Nativa
- Tiempo de ejecución de Android
- API de Java
- Aplicación del sistema
- CPI
- Aglutinante
- Máquina virtual Dalvik
- Sandboxing (caja de arena)
- Usuario y grupo
- Sistema de archivos / Partición
- Archivo
- Base de datos
- SQLite: 

# Permisos

- Application level : [[ 1 ]](https://developer.android.com/guide/topics/permissions/overview)
- Protection levels
- Custom Permissio

# Componentes de la aplicación

- Actividad : [ 1 ]
- Servicio : [ 1 ]
- Receptor de transmisión: [ 1 ]
- Proveedor de contenido: [ 1 ]
- Manifiesto: [ 1 ]
- Intención: [ 1 ] - [ 2 ]

# API principal

- Criptografía: [ 1 ]
- Interacción con otras aplicaciones: [ 1 ]
- Interfaz de usuario: [ 1 ]
- Imágenes y gráficos: [ 1 ]
- Audio y vídeo: [ 1 ]
- procesamiento en segundo plano: [ 1 ]
- Datos y archivos de la aplicación: [ 1 ]
- Toque y entrada: [ 1 ]
- Sensores: [ 1 ]
- Conectividad: [ 1 ]

# Interacción con el servidor

- Confidencialidad y Autenticación
- Biblioteca HTTP
- OkHttp
- Voleo
- Modernización
- Suite para eructos
- Fijación SSL
- Validación de certificados
- Proxy y sniffer para tráfico HTTP
- Implementación de SSL/TLS

# Análisis estático

- Proceso de desarrollo de APK
- Estructura del APK: [ 1 ]
- Descompilación
- JADX
- Herramienta APK
- Parcheo de código
- Código nativo
- Desmontaje
- Ghidra
- IDA

# Análisis dinámico
- Rastreo de pila
- Enganche
- Depuración
- Banco Asiático de Desarrollo
- Emulador
- Movimiento genético
- AVD
- Bluestack
- Detección / Bypass
- Maquina virtual
- PIN SSL
- Enraizamiento
- Herramientas
- Frida
- Drozer
- Objeción
- Expuesto
- RMS

# Ataques comunes
- Transmisión de datos insegura
- IPC inseguro
- Problema de permiso
- Almacenamiento de datos inseguro
- Problema con la vista web
- Registros inseguros

> [!NOTE]
> La mayoría de los dispositivos Android funcionan con ARM 


# Assembly 

**Comnados**
 - [as](https://sourceware.org/binutils/docs/as/index.html#Top)  : De lenguage emsablador a codigo maquina   
 - [ld](https://sourceware.org/binutils/docs/ld/)  : 


**[Intoducion al los comceptos basicos de  ensamblaje arm](https://azeria-labs.com/writing-arm-assembly-part-1/)**


# ROP 


# Desarollo de  exploit `ARM` 

 [1](https://fuzzysecurity.com/tutorials/expDev/1.html) 

 [2](https://www.corelan.be/index.php/2009/07/19/exploit-writing-tutorial-part-1-stack-based-overflows/) 

# [Radare2](https://book.rada.re/config/evars.html)

- **CLI**
    - `-d ` : 
- **Inter**
    - "iE"  : 
    - `bdi` : Punto de intrucsion
    - `pdda` : Comando para ver el ensamblado y el código fuente descompilado uno al lado del otro.
    - *Debug commands* 
        - `d `

**Plugings**

- `r2dec` : Descompilador 


**Introducción a la interfaz nativa de Java (JNI)**

La interfaz nativa de Java (JNI) permite a los desarrolladores declarar métodos Java implementados en código nativo (normalmente compilado en C/C++). La interfaz JNI no es específica de Android, pero está disponible de forma más general para aplicaciones Java que se ejecutan en diferentes plataformas.

**Documentación de Oracle JNI**

- [Espesificacion de JNI](https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/jniTOC.html)
- [Funciones de JNI](https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html) <<-- __Siempre tengo esta abierta y la consulto mientras invierto bibliotecas nativas de Android__


**Referencias de JNI y NDK de Android**

- [Consejos sobre JNI para Android](https://developer.android.com/training/articles/perf-jni) <-- Recomiendo leer la sección "Bibliotecas nativas" para comenzar
- [Introducción al NDK](https://developer.android.com/ndk/guides/) <-- Esta es una guía sobre cómo los desarrolladores desarrollan bibliotecas nativas y comprenden cómo se construyen las cosas, lo que hace que sea más fácil revertirlas.

### Analisis Estatico

- **Buscar cadenas**
    - (contraseñas, URL, API, cifrado, puertas traseras, tokens, UUID de Bluetooth...)
    - Atención especial a las [API de Firebase](https://hacktricks.boitatech.com.br/pentesting/pentesting-web/buckets/firebase-database)
- **Leer el manifiesto**
    - Comprueba si el APK permite realizar copias de seguridad
    - Actividades exportadas
    - Servicios expuestos
    - Esquemas de URL 

### Analisis Dinamico 

 - Existe alguna fuga de datos no intencionada (registro, copiar/pegar, registros de fallos)?

- ¿Se guarda información confidencial en bases de datos SQLite ?

- ¿Actividades expuestas explotables ?

- ¿Proveedores de contenido explotables ?

- ¿Servicios expuestos explotables ?

- ¿Receptores de transmisión explotables ?

- ¿La aplicación transmite información en texto claro o utilizando algoritmos débiles ? ¿Es posible un MitM?

- Inspeccionar el tráfico HTTP/HTTPS
    - Esto es realmente importante, porque si puedes capturar el tráfico HTTP puedes buscar vulnerabilidades web comunes (Hacktricks tiene mucha información sobre vulnerabilidades web).

- Compruebe si hay posibles inyecciones del lado del cliente de Android (probablemente algún análisis de código estático ayudará aquí)

- Frida : Sólo Frida, úsala para obtener datos dinámicos interesantes de la aplicación (quizás algunas contraseñas...

### Analisis Dinamico en Linea

Puedes crear una cuenta gratuita en: ``https://appetize.io/`` . Esta plataforma te permite subir y ejecutar APKs, por lo que es útil para ver cómo se comporta un apk.

Incluso puedes ver los registros de tu aplicación en la web y conectarte a través de adb .


### Referencias CTF

- [root-me](url) 


# Contenido de la comunidad

- [aqui](url) 

# Pendientes por resolver

- [aqui](url)


# Foros que me llamaron la atencion 
[bypassing-root-detection](https://medium.com/@aimardcr/bypassing-root-detection-the-universal-way-2625712172e5) 

[BypassSelinux](https://klecko.github.io/posts/selinux-bypasses/) 

[](https://nelenkov.blogspot.com/2015/06/password-storage-in-android-m.html?m=1)

[Seguridad de android](https://github.com/Ralireza/Android-Security-Teryaagh) 

[Buscar numeros magicos](https://www.garykessler.net/library/file_sigs.html)

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



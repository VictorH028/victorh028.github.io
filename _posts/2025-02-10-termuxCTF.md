---
comments: true
layout: single
title: TermuxCTF  
date: 2025-02-10 
classes: wide
header:
  tease: /assets/images/ 
  teaser_home_page: true
categories:
  - termux
  - radare2
tags:
  - analis
  - radare2
  - termux 
---

Mucho gusto me presento  soy usuario activo de la comunidad de [ivam3 cindarela](). Soy cubano y curso el primer año de ingeneniería software  y opero bajo el alias de *DemonHunter*. 

> [!NOTE]
> No te quedes con la duda de nada si no lo explico o no lo entiendes a buscalo en Internet 

__Sin más preámbulo para que estamos acá.__

En ocasiones no cumplimos nuestras metas por que no te nemos los recuerdos necesarios o esos creemos quien no tiene un dispositivo Android en su poder hoy en día. Usando termux será lo que usted desee. 


Los temas sentrales que estaré tocando serán de análisis a binarios y ingeniería inversa usando [termux]() el objetivo no será optener la bandera sino tocar en detalles los aspectos a tender en cuenta para llegar a la meta . 

Comenzando con nuestro primer CTF en la plataforma de [Tryhackme](https://tryhackme.com/room/reverse files) ...
    
    1. Procedemos a descargar el archivo de el primer desafío 

Estaremos asiendo un _análisis estatico_ del mismo 
    
**En que consiste el análisis estático**

    - Análisis el archivo sin ejecutarlo 😎

Aunque quisiéramos no podriamos ejecutarlo entre comillas. Pero bueno no es el caso ahora...

Empezamos con lo más básico que es saber a que nos estamos enfrentando usando. 

```sh
file crackme1
```

```sh
crackme1: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=672f525a7ad3c33f190c060c09b11e9ffd007f34, not stripped
```

Estructurado la salida optenida vamos a ver lo que tenemos un archivo `ELF 64 bist executable` compilado para  `x86-64 ` y el `LSB` lo que significa que los números se ordenan con ``byte`` menos significativo en memoria. 

Estaremos utilizando la herramienta de [radare2](url)  qué se puede instalar desde el administrador de paquetes `apt` con `apt install radare2` 

Procedemos a abrir el binario en `r2` 

Banderas:
`-A` : Para que analise todo el código referenciado 

El comando 'print' se abrevia como `p` y tiene varios submodos pero no te agobies si le añades `? ` tendrás un menú de ayuda.  



Procedemos a desmontar la función principal que no es siempre el caso hay programas que ejecutan funcinoes antes de `main`.

`pdf @ main` 

```asm
[0x00400450]> pdf@main
            ; ICOD XREF from entry0 @ 0x40046d(r)
┌ 321: int main (int argc, char **argv);
│ `- args(rdi, rsi) vars(31:sp[0xc..0xa8])
│           0x00400546      55             push rbp
│           0x00400547      4889e5         mov rbp, rsp
│           0x0040054a      4881eca000..   sub rsp, 0xa0
│           0x00400551      89bd6cffffff   mov dword [var_94h], edi    ; argc
│           0x00400557      4889b560ff..   mov qword [var_a0h], rsi    ; argv
│           0x0040055e      c745902500..   mov dword [var_70h], 0x25   ; '%' ; 37
│           0x00400565      c745942b00..   mov dword [var_6ch], 0x2b   ; '+' ; 43
│           0x0040056c      c745982000..   mov dword [var_68h], 0x20   ; 32
│           0x00400573      c7459c2600..   mov dword [var_64h], 0x26   ; '&' ; 38
│           0x0040057a      c745a03a00..   mov dword [var_60h], 0x3a   ; ':' ; 58
│           0x00400581      c745a42d00..   mov dword [var_5ch], 0x2d   ; '-' ; 45
│           0x00400588      c745a82e00..   mov dword [var_58h], 0x2e   ; '.' ; 46
│           0x0040058f      c745ac3300..   mov dword [var_54h], 0x33   ; '3' ; 51
│           0x00400596      c745b01e00..   mov dword [var_50h], 0x1e   ; 30
│           0x0040059d      c745b43300..   mov dword [var_4ch], 0x33   ; '3' ; 51
│           0x004005a4      c745b82700..   mov dword [var_48h], 0x27   ; '\'' ; 39
│           0x004005ab      c745bc2000..   mov dword [var_44h], 0x20   ; 32
│           0x004005b2      c745c03300..   mov dword [var_40h], 0x33   ; '3' ; 51
│           0x004005b9      c745c41e00..   mov dword [var_3ch], 0x1e   ; 30
│           0x004005c0      c745c82a00..   mov dword [var_38h], 0x2a   ; '*' ; 42
│           0x004005c7      c745cc2800..   mov dword [var_34h], 0x28   ; '(' ; 40
│           0x004005ce      c745d02d00..   mov dword [var_30h], 0x2d   ; '-' ; 45
│           0x004005d5      c745d42300..   mov dword [var_2ch], 0x23   ; '#' ; 35
│           0x004005dc      c745d81e00..   mov dword [var_28h], 0x1e   ; 30
│           0x004005e3      c745dc2e00..   mov dword [var_24h], 0x2e   ; '.' ; 46
│           0x004005ea      c745e02500..   mov dword [var_20h], 0x25   ; '%' ; 37
│           0x004005f1      c745e41e00..   mov dword [var_1ch], 0x1e   ; 30
│           0x004005f8      c745e82400..   mov dword [var_18h], 0x24   ; '$' ; 36
│           0x004005ff      c745ec2b00..   mov dword [var_14h], 0x2b   ; '+' ; 43
│           0x00400606      c745f02500..   mov dword [var_10h], 0x25   ; '%' ; 37
│           0x0040060d      c745f43c00..   mov dword [var_ch], 0x3c    ; '<' ; 60
│           0x00400614      c745f8bfff..   mov dword [var_8h], 0xffffffbf ; 4294967231
│           0x0040061b      488d8570ff..   lea rax, [s]
│           0x00400622      ba1b000000     mov edx, 0x1b               ; 27 ; size_t n
│           0x00400627      be41000000     mov esi, 0x41               ; 'A' ; 65 ; int c
│           0x0040062c      4889c7         mov rdi, rax                ; void *s
│           0x0040062f      e8ecfdffff     call sym.imp.memset         ; void *memset(void *s, int c, size_t n)
│           0x00400634      c745fc0000..   mov dword [var_4h], 0
│       ┌─< 0x0040063b      eb2c           jmp 0x400669
│       │   ; CODE XREF from main @ 0x40066f(x)
│      ┌──> 0x0040063d      8b45fc         mov eax, dword [var_4h]
│      ╎│   0x00400640      4898           cdqe
│      ╎│   0x00400642      0fb6840570..   movzx eax, byte [rbp + rax - 0x90]
│      ╎│   0x0040064a      89c2           mov edx, eax
│      ╎│   0x0040064c      8b45fc         mov eax, dword [var_4h]
│      ╎│   0x0040064f      4898           cdqe
│      ╎│   0x00400651      8b448590       mov eax, dword [rbp + rax*4 - 0x70]
│      ╎│   0x00400655      01d0           add eax, edx
│      ╎│   0x00400657      89c2           mov edx, eax
│      ╎│   0x00400659      8b45fc         mov eax, dword [var_4h]
│      ╎│   0x0040065c      4898           cdqe
│      ╎│   0x0040065e      88940570ff..   mov byte [rbp + rax - 0x90], dl
│      ╎│   0x00400665      8345fc01       add dword [var_4h], 1
│      ╎│   ; CODE XREF from main @ 0x40063b(x)
│      ╎└─> 0x00400669      8b45fc         mov eax, dword [var_4h]
│      ╎    0x0040066c      83f81a         cmp eax, 0x1a               ; 26
│      └──< 0x0040066f      76cc           jbe 0x40063d
│           0x00400671      488d8570ff..   lea rax, [s]
│           0x00400678      4889c7         mov rdi, rax                ; const char *s
│           0x0040067b      e890fdffff     call sym.imp.puts           ; int puts(const char *s)
│           0x00400680      b800000000     mov eax, 0
│           0x00400685      c9             leave
└           0x00400686      c3             ret
[0x00400450]>
``` 

### Buscando instrucciones relacionada con la pila 

   - Las instrucciones que manipulan la pila suelen ser:
     - `push`: Guarda un valor en la pila.
     - `pop`: Extrae un valor de la pila.
     - `mov [rbp - X], Y`: Guarda un valor en una posición específica de la pila.
     - `lea`: Carga una dirección de memoria en un registro (a menudo usado para direccionar la pila).

Sabiendo lo anterior vemos que varios valores se guardan el la  `pila`  estos valores se almacenan en posiciones relativas al registro `rbp` que sería `rbp - 0x70, rbp - 0x6c` ect...  

radare2 agrega comentarios en automático en el código, esto nos ayuda e entender que valores se están guardando pero parese ser la bandera. 


### ¿ Qué son los registros? 

Los egistro de procesador es una ubicación de acceso rápido disponible para el procesador de una computadora

Los registros de `64 bits` tienen nombres que comienzan con “r”, por lo que, por ejemplo, la extensión de 64 bits de `eax` se llama `rax`. Los nuevos registros se denominan `r8` a `r15` ojo con los hibridos xD:

### Llamada a funciones 

Cuando se llama a una función, el compilador utiliza un marco de pila (ubicado dentro de la pila de ejecución del programa ) para almacenar toda la información temporal que la función requiere para operar. Dependiendo de la convención de llamada, la función que llama colocará la información antes mencionada en registros específicos o en la pila del programa o en ambos.

En Linux, se colocarán los argumentos en los registros `RDI`, `RSI`, `RDX`, `RCX`, `R8` y `R9` y cualquier cosa adicional se colocará en la pila.


Tenemos dos llamadas a  función y una es  la función `memset()` y `puts()` qué la podemos identificar por la instrucción de `call` qué es la encargada de llamar a un  función.

Ya sabiendo lo anterior tenemos una función llamada `memset() ` y los valores que toma por argumento . Buscando en Internet vemos que `C` cuenta con una función del mismo nombre y no es creada por el usuario. (ojo)

El código llama a `memset` para inicializar un bloque de memoria con el valor `0x41` (`'A'`):

   ```asm
   lea rax, [s]
   mov edx, 0x1b               ; 27 ; size_t n
   mov esi, 0x41               ; 'A' ; 65 ; int c
   mov rdi, rax                ; void *s
   call sym.imp.memset         ; void *memset(void *s, int c, size_t n)
   ```
   
Esto llena 27 bytes con el carácter `'A'`.

Después nos topamos con un bucle que  realiza una operación de transformación sobre los valores inicializados. 

### **Inicialización del bucle**
   ```asm
   mov dword [var_4h], 0
   jmp 0x400669
   ```

### **Cuerpo del bucle**
   ```asm
   mov eax, dword [var_4h]
   cdqe
   movzx eax, byte [rbp + rax - 0x90]
   mov edx, eax
   mov eax, dword [var_4h]
   cdqe
   mov eax, dword [rbp + rax*4 - 0x70]
   add eax, edx
   mov edx, eax
   mov eax, dword [var_4h]
   cdqe
   mov byte [rbp + rax - 0x90], dl
   add dword [var_4h], 1
   ```

- El bucle itera sobre un arreglo de bytes.
- Para cada iteración, toma un valor del arreglo `[rbp + rax - 0x90]` y lo suma con un valor del arreglo `[rbp + rax*4 - 0x70]`.
- El resultado se almacena de nuevo en `[rbp + rax - 0x90]`.

###  **Condición del bucle**
   ```asm
   cmp eax, 0x1a               ; 26
   jbe 0x40063d
   ```
   - El bucle se ejecuta mientras `eax` sea menor o igual a `0x1a` (26).

Después del bucle, el código imprime el contenido de `[s]` usando `puts`:

   ```asm
   lea rax, [s]
   mov rdi, rax                ; const char *s
   call sym.imp.puts           ; int puts(const char *s)
   ```

El bucle realiza una operación de transformación sobre los valores inicializados. Podemos inferir que:

- El arreglo `[rbp - 0x90]` contiene 27 bytes inicializados con `'A'`.
- El arreglo `[rbp - 0x70]` contiene los valores constantes inicializados al principio.
- Para cada byte en `[rbp - 0x90]`, se suma el valor correspondiente de `[rbp - 0x70]` y se almacena el resultado.

Bueno ya sabemos lo que esta haciendo el programa esta generando una cadena transformada a partir de los valores guardados en la pila sabiendo esto vamos a tratar de recrear el programa bueno no lo dejo de tarea. Bueno acá el resumen. 

Podemos realizar la operación matemática directa mente de la línea de comandos de radare2 usando la calculadora integrada usando el comando de `? (valores) ` permite hacer cálculos en diferentes bases 

`? 0x41 + 0x25`




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



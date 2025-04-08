---
layout: default
comments: true
layout: single
title: x86-assembler-learning
date: 2025-04-07
classes: wide
header:
  teaser: /assets/images/
  teaser_home_page: true
categories:
  - notas 
tags:
  - assembly
  - linux
---

# Compilado 

Entonces, primero, ¿qué es el código ensamblador? El código ensamblador es el código que el procesador realmente ejecuta en su computadora. Por ejemplo, tome un código C:

```C
#include <stdio.h>

void main(void)
{
    puts("Hello World!");
}
```
Ese código no se ejecutó. La cuestión es que el código se compila en código ensamblador, que se ve así:

![hello_asm](/assets/images/assembler/hello_asm.jpg)

También con el código ensamblador, hay muchas arquitecturas diferentes. Diferentes tipos de procesadores pueden ejecutar diferentes tipos de arquitecturas de código ensamblador. Los dos que más trataremos aquí serán ELF (formato ejecutable y enlazable) de 64 bits y de 32 bits. A menudo llamaré a estas dos cosas `x64`y `x86`.

# Registers
En una computadora, un registro es uno de un pequeño conjunto de datos que tienen lugares que forman parte de un procesador de computadora. Un registro puede mantener una instrucción de computadora, una dirección de almacenamiento o cualquier tipo de datos (como una secuencia de bits o caracteres individuales). Los procesadores modernos (I.E 386 y más allá) X86 tienen ocho registros de 32 bits de propósito general 

![Registers](/assets/images/assembler/Registers.jpg)

```
rbp: Puntero base, apunta a la parte inferior del marco de pila actual
rsp: Puntero de pila, apunta a la parte superior del marco de pila actual
rip: Puntero de instrucciones, apunta a la instrucción a ejecutar.

Registros de propósito general
Estos se pueden utilizar para una variedad de cosas diferentes.
rax:
rbx:
rcx: cuarto argumento 
rdx: terser argumento 
rsi: segundo argumento 
rdi: primer argumento 
r8:
r9:
r10:
r11:
r12:
r13:
r14:
r15:
```

En `x64`Linux, los argumentos de una función se pasan a través de registros. Los primeros argumentos pasan por estos registros:

```
rdi:    First Argument
rsi:    Second Argument
rdx:    Third Argument
rcx:    Fourth Argument
r8:     Fifth Argument
r9:     Sixth Argument
```

Con la `x86`arquitectura elf, los argumentos se pasan a la pila. También una cosa, como sabrá, en la función C puede devolver un valor. En `x64`, este valor se pasa en el `rax` registro. En `x86`este valor se pasa en el `eax` registro.

También una cosa, hay diferentes tamaños para los registros. Estos tamaños típicos con los que trataremos son `8`bytes, `4`bytes, `2`bytes y `1`. La razón de estos diferentes tamaños se debe al avance de la tecnología, podemos almacenar más datos en un registro.

| 8 Bytes Registe4 | Lower 4 Bytes | Lower 2 Bytes | Lower Bytes |
| ---------------- | ------------- | ------------- | ----------- |
| rbp              | ebp           | bp            | bpl         |
| rsp              | esp           | sp            | spl         |
| rip              | eip           |               |             |
|   rax           |     eax       |     ax        |     al     |
|   rbx           |     ebx       |     bx        |     bl     |
|   rcx           |     ecx       |     cx        |     cl     |
|   rdx           |     edx       |     dx        |     dl     |
|   rsi           |     esi       |     si        |     sil    |
|   rdi           |     edi       |     di        |     dil    |
|   r8            |     r8d       |     r8w       |     r8b    |
|   r9            |     r9d       |     r9w       |     r9b    |
|   r10           |     r10d      |     r10w      |     r10b   |
|   r11           |     r11d      |     r11w      |     r11b   |
|   r12           |     r12d      |     r12w      |     r12b   |
|   r13           |     r13d      |     r13w      |     r13b   |
|   r14           |     r14d      |     r14w      |     r14b   |
|   r15           |     r15d      |     r15w      |     r15b   |

En `x64`veremos los `8`registros de bytes. Sin embargo, `x86`los registros de mayor tamaño que podemos usar son los `4`registros de bytes como `ebp`, `esp`, `eip`etc. Ahora también podemos usar registros más pequeños que los registros de tamaño máximo para la arquitectura.

Allí `x64`está el registro `rax`, `eax`, `ax`y . `al`El `rax`registro apunta al pleno `8`. El `eax`registro es solo los cuatro bytes inferiores del `rax`registro. El `ax`registro son los últimos `2`bytes del `rax`registro. Por último, el `al`registro es el último byte del `rax`registro.



# The Stack, Stack Pointer, and Base Pointer

Ahora, una de las regiones de memoria más comunes con las que trabajará es la pila. Es donde se almacenan las variables locales en el código.

Por ejemplo, en este código la variable `x`se almacena en la pila:

```C
#include <stdio.h>

void main(void)
{
    int x = 5;
    puts("hi");
}
```
Específicamente, podemos ver que está almacenado en la pila en `rbp-0x4`.

![stack](/assets/images/assembler/stack.jpg)

Ahora los valores en la pila se mueven empujándolos a la pila o sacándolos. Esa es la única forma de agregar o eliminar valores de la pila (es una estructura de datos LIFO). Sin embargo, podemos hacer referencia a valores en la pila.

Los límites exactos de la pila se registran mediante dos registros, `rbp`y `rsp`. El puntero base `rbp`apunta a la parte inferior de la pila. El puntero de la pila `rsp`apunta a la parte superior de la pila.


El puntero de la pila suele ser un registro que contiene la parte superior de la pila. El puntero de la pila contiene la dirección más pequeña X de tal manera que cualquier dirección más pequeña que x se considera basura.

Siempre que se llama una función, se inicia un nuevo marco de pila. -Este se llama la función Prolog.

`push rbp` ; Preservar el puntero de marco actual

`mov rbp, rsp` ; Cree un nuevo puntero de marco que apunte a la parte superior de la pila actual

`sub esp, 0x10` ; Asignar `10` bytes por valor de los locales en la pila.

La pila crece hacia las direcciones de memoria más bajas. Cuando se declara una variable local, se decrementa el puntero de la pila (`rsp`). El espacio entre el puntero base (`rbp`) y el puntero de la pila es donde se almacenan todas las variables locales.

Como se muestra en la imagen, la variable local `1` se encuentra en la dirección de la memoria `ebp-0x4.`

![the_stack](/assets/images/assembler/the_stack.jpg)

# 64 Bit Assembly Instructions (Intel)

## Puntero de instrucción (rip, eip)

Es un registro que indica cuál es la siguiente instrucción a ejecutar. Cada vez que el procesador ejecuta una instrucción, actualiza el valor del puntero de instrucción para que apunte a la siguiente instrucción que se ejecutará. Para ello, su valor se incrementa en función del tamaño de la instrucción.


| `<instrucion>` | `<destination>` | `<source>` |
| ------------- | --------------- | ---------- |
|   `mov`              |         `rax`         |        `ebx`    |


### MOV
La instrucción `mov` copia el elemento de datos a que se refiere su segundo operando en la ubicación mencionada por su primer operando. Mientras que los movimientos de registro para registrarse son posibles, los movimientos directos de memoria a la memoria no lo son. En los casos en que se deseen las transferencias de memoria, los contenidos de la memoria de origen primero deben cargarse en un registro, luego se pueden almacenar a la dirección de memoria de destino.

Los `[]` son como un dereferencer en C (* PTR). Así que `esp+0x4` es la ubicación en la memoria y `[esp+0x4]` es lo que está contenido en esa ubicación

 ## Examoles
| Syntac             | Examples       |
| ------------------ | -------------- |
| `mov <reg>,<reg> ` | `mov rax, rbx` |


Copia el valor en `rbx` en `rax`

| Syntax | Example |
| ------ | ------- |
| `mov <reg>,<mem>`       | `mov rax, [rbp-0x0]`        |

Copie el valor de la variable almacenada en la dirección de la memoria `rbp-0x4` en el registro `rax`

| Sintax | Example |
| ------ | ------- |
| `mov <mem>,<reg>`       |   `mov [rbp-0x4],rbx`      |

 Mueva el contenido de `rbx` a los 4 bytes en la dirección de la memoria `ebp-0x4`


En algunos casos, el tamaño de una región referida a memoria es ambigua. Considere la instrucción `mov [rbx], 2`. ¿Debe esta instrucción mover el valor `2` en el byte único en la dirección `rbx`? Tal vez debería mover la representación de enteros de 32 bits de 2 en el inicio de 4 bytes en la dirección `rbx`. Dado que cualquiera es una interpretación posible válida, el ensamblador debe dirigirse explícitamente en cuanto a lo que es correcto. Las directivas de tamaño `BYTE PTR, WORD PTR` y `DWORD PTR` sirven a este propósito, lo que indica tamaños de 1, 2 y 4 bytes respectivamente.

`mov BYTE PTR [ebx], 2 ;`
Mueva 2 en el único byte en la dirección almacenada en EBX.

`mov WORD PTR [ebx], 2 ;`
Mueva la representación entera de 16 bits de 2 en los 2 bytes que comienzan en la dirección en EBX

`mov DWORD PTR [ebx], 2 ;`
Mueva la representación entera de 32 bits de 2 en los 4 bytes que comienzan en la dirección en EBX.

# sub
Este valor restará el segundo operando del primero y almacenará la diferencia en el primer argumento. Por ejemplo:

`sub rsp, 0x10`

Esto establecerá el `rsp`registro igual a`rsp - 0x10`


# CALL/RET
call, ret — Llamada de subrutina y devolución

Estas instrucciones implementan una llamada de subrutina y devuelve. La instrucción de llamadas primero empuja la ubicación del código actual en la pila admitida de hardware en la memoria, y luego realiza un salto incondicional a la ubicación del código indicada por el operando de la etiqueta. A diferencia de las instrucciones de salto simples, la instrucción de llamadas guarda la ubicación para volver a la hora de que se complete la subrutina.

Antes de llamar a una función, sus argumentos se colocan en la pila.  Entonces, si alguna vez quiere saber qué se está pasando a una función,
 solo mire lo que se pone en la pila directamente antes de su `call`.
 
La instrucción `res` implementa un mecanismo de retorno de subrutina.  Esta instrucción primero saca una ubicación de código del hardware compatible pila en memoria.  Luego realiza un salto incondicional a la ubicación del código recuperado.

El valor de retorno de una función siempre se mueve a `eax`. Entonces, para ver qué se devolvió una función, solo mire a `eax` después de la llamada.

### Syntax
`call <function>`
`ret`


### desreferencia

Si alguna vez ve corchetes como `[]`, significan que no hacen referencia a los punteros. Un puntero es un valor que apunta a una dirección de memoria particular (es una dirección de memoria). Desreferenciar un puntero significa tratar un puntero como el valor al que apunta. Por ejemplo:

`mov rax, [rdx]`

Moverá el valor señalado por `rdx`en el `rax`registro. Por otro lado:

`mov [rax], rdx`

Moverá el valor del `rdx`registro a cualquier memoria a la que apunte el `rax`registro. El valor real del `rax`registro no cambia.

# lea

La instrucción lea coloca la dirección especificada por su segundo operando en el registro especificado por su primer operando. Nota, el contenido de la ubicación de la memoria no se carga, solo se calcula la dirección efectiva y se coloca en el registro. Esto es útil para obtener un puntero en una región de memoria.

#### Syntax
`lea  <reg32>,<mem>`
#### Examples
`lea edi, [ebx+4*esi]` — La cantidad `EBX+4*ESI` se coloca en EDI.
`lea eax, [esp+0x8]` — El valor en `va` se coloca en `eax`.

# add

Esto simplemente suma los dos valores y almacena la suma en el primer argumento. Por ejemplo:

#### Syntax      
`add <destination>,<source>`

#### Examples
`add eax, 0x10;` EAX ← EAX + 10
`add eax, ebx;`  Añadir el contenidos de EBX al contenido de eax

# xor

Esto realizará la operación binaria xor en los dos argumentos que se le dan, y almacenará el resultado en la primera operación:

`xor rdx, rax`

Eso establecerá el `rdx`registro igual a `rdx ^ rax`.

Las operaciones `and`and `or`hacen esencialmente lo mismo, excepto con los operadores binarios and or or .

# PUAH

La `push`instrucción hará crecer la pila en `8`bytes (for `x64`, `4`for `x86`), luego empujará el contenido de un registro al nuevo espacio de la pila. Por ejemplo:

`push rax`

Esto aumentará la pila por `8`bytes, y el contenido del `rax`registro estará en la parte superior de la pila.

## Syntax
`push <reg>`
`push <mem>`
`push <con32>`

### Examples
`push eax` — Enpuja `eax` en la pila
`push [var]` — Empuje los `4 bytes` en la dirección var en la pila


# pop

La `pop`instrucción sacará los `8`bytes superiores (8 for `x64`, `4`for `x86`) de la pila y los colocará en el argumento. Entonces reducirá la pila. Por ejemplo:

`pop rax`

Los bytes superiores `8`de la pila terminarán en el `rax`registro.

# jmp

La `jmp`instrucción saltará a una dirección de instrucción. Se utiliza para redirigir la ejecución del código. Por ejemplo:

`jmp 0x602010`

Esa instrucción hará que la ejecución del código salte a `0x602010`y ejecute cualquier instrucción que esté allí.


# cmp
Compare los valores de los dos operandos especificados, configurando los códigos de condición en la palabra de estado de la máquina adecuadamente.

Los contenidos de la palabra estado de la máquina incluyen información sobre la última operación aritmética realizada. Por ejemplo, un bit de esta palabra indica si el último resultado fue cero. Otro indica si el último resultado fue negativo. Basado en estos códigos de condición, se pueden realizar varios saltos condicionales.

Esta instrucción es equivalente a la `sub` Instrucción, excepto que el resultado de la resta se descartó en lugar de reemplazar el primer operando.

### Syntax
`cmp <arg1>,<arg2>`


# JUMP
Se administran nombres de las ramas condicionales que se basan intuitivamente en la última instrucción de comparación, `cmp`. Por ejemplo, las ramas condicionales como `jle` y `jne` se basan en la primera vez que realizan una operación de `cmp` en los operandos deseados.

### Syntax

`je <label>` (salta cuando es igual)

`jne <label>` (saltar cuando no es igual)

`jz <label>` (saltar cuando el último resultado fue cero)

`jg <label>` (salta cuando es mayor que)

`jge <label>` (salta cuando es mayor o igual que)

`jl <label>` (salta cuando menos de)

`jle <label>` (salta cuando es menor o igual que)

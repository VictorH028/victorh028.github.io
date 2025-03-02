
Mucho de el contenido acá mensionado se trabajará en termux con la utilidad de [termux-docker-qemu]()  . 

# ¿Qué es el análisis binario y por qué lo necesita?

.......?

## Análisis estático
Las técnicas de análisis estático  sobre un binario sin  ejecutándolo. Este enfoque tiene varias ventajas: potencialmente puedes   analiza todo el binario de una sola vez y no necesitas una CPU que pueda ejecuta el binario. Por ejemplo, puedes analizar estáticamente un binario `ARM` en una máquina `x86`. La desventaja es que el análisis estático no tiene conocimiento del estado de ejecución del binario, lo que puede hacer que el análisis sea muy complicado y desafiante.
    
## Análisis dinámico     
Por el contrario, el análisis dinámico ejecuta el binario y lo analiza a medida que se ejecuta. Este enfoque suele ser más simple que el análisis estático. porque tiene pleno conocimiento de todo el estado de ejecución, incluido los valores de las variables y los resultados de las ramas condicionales. 

## **Sintaxis de ensamblaje**       
Existen dos formatos de sintaxis populares que se utilizan para   representar instrucciones de máquina `x86`: sintaxis `Intel` y sintaxis `AT&T`. aquí voy a   Utilice la sintaxis `Intel` porque es menos detallada. 

En la sintaxis de `Intel`, mover una constante   en el registro *edi* se ve así:                                  

```c
mov   edi,0x6
```


## Proceso de computación **C**

Los binarios se producen mediante compilación, que es el proceso de traducir código fuente legible por humanos, como C o C++, a código de máquina que su procesador puede ejecutar  los pasos involucrados en un proceso típico proceso de compilación para código C (los pasos para la compilación de C++ son similares).                            
La compilación de código C implica cuatro fases, una de las cuales (por extraño que parezca) es también se llama compilación, al igual que el proceso de compilación completo. Las fases son ==preprocesamiento, compilación, ensamblaje y vinculación==. 

En la práctica, los compiladores modernos  a menudo fusionamos algunas o todas estas fases, pero para fines de demostración,  los cubriremos todos por separado.
### La fase de preprocesamiento

El proceso de compilación comienza con una cantidad de archivos fuente que desea   para compilar . Es posible   tener un solo archivo fuente, pero los programas grandes generalmente se componen de muchos  archivos. Esto no sólo hace que el proyecto sea más fácil de gestionar, sino que también acelera la compilación porque si un archivo cambia, solo tienes que volver a compilar ese archivo   en lugar de todo el código.                            
Los archivos fuente C contienen macros (` #define`) y directivas `#include`. Utilice las directivas `#include` para incluir archivos de encabezado (con la extensión `.h` ) de los que depende el archivo fuente. La fase de preprocesamiento se expande   cualquier directiva `#define` y `#include` en el archivo fuente, por lo que todo lo que queda es C puro código listo para ser compilado.                          
Hagamos esto más concreto mirando un ejemplo. este ejemplo utiliza el compilador *gcc*, que es el predeterminado en muchas distribuciones de Linux


- *ejemplo_compilacion.c*
```c
#include <stdio.h>

#define STRING_FORMAT "%s"
#define MESSAGE       "Hello World\n" 

int main(int argc, char *argv[]){
  printf(STRING_FORMAT,MESSAGE);
  return 0;
}
```

De forma predeterminada, `gcc` ejecutará automáticamente toda la fases de compilación, por lo que debe indicarle explícitamente que se detenga después del ==preprocesamiento== y que muestre             usted la salida intermedia. Para `gcc,` esto se puede hacer usando el comando     `gcc -E -P`, donde `-E` le dice a **gcc** que se detenga después del preprocesamiento y `-P` provoca que  el compilador omita la información de depuración para que la salida sea un poco más limpia.

###  La fase de compilación       
Una vez completada la fase de preprocesamiento, el código fuente está listo para ser compilado. La fase de compilación toma el código preprocesado y lo traduce.   
A lenguaje ensamblador. (La mayoría de los compiladores también realizan una gran optimización en  esta fase, normalmente configurable como un nivel de optimización mediante comando   conmutadores de línea como las opciones `-O0` a `-O3` en `gcc`. Como verá más adelante el grado de optimización durante la compilación puede tener un profundo impacto y   efecto en el desmontaje.)       

**¿Por qué la fase de compilación produce lenguaje ensamblador y no?¿código máquina? **

Esta decisión de diseño no parece tener sentido en el contexto de un solo lenguaje (en este caso, C), pero sí lo tiene cuando se piensa en   todos los demás idiomas que existen. Algunos ejemplos de lenguajes compilados populares incluyen `C`, `C++`, `Objective-C`, `Common Lisp`, `Delphi`, `Go` y `Haskell`.

Como se mencionó, `gcc`  normalmente llama a todas las fases de compilación automáticamente, por lo que para ver el archivo emitido   ensamblaje desde la etapa de compilación, debes decirle a `gcc` que se detenga después de esto   etapa y almacenar los archivos de ensamblaje en el disco. Puedes hacer esto usando el indicador `-S`   (`.s` es una extensión convencional para archivos de ensamblaje). También pasas la opción.  `-masm=intel` a `gcc` para que emita ensamblado en sintaxis Intel           

---
```sh
$ gcc -S -masm=intel ejemplo_compilacion.c
$ cat compilation_example.s
.file"ejemplos_compilacion.c"
.intel_syntax noprefix
.section
.rodata
.LC0:
.string"Hello, world!"
.text
.globlmain
.typemain, @function
main:
.LFB0:
.cfi_startproc
pushrbp
.cfi_def_cfa_offset 16
.cfi_offset 6, -16
movrbp, rsp
.cfi_def_cfa_register 6
subrsp, 16
movDWORD PTR [rbp-4], edi
movQWORD PTR [rbp-16], rsi
movedi,OFFSET FLAT:.LC0
callputs
moveax, 0
leave
.cfi_def_cfa 7, 8
ret
.cfi_endproc
.LFE0:
.sizemain, .-main
.ident"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
.section .note.GNU-stack,"",@progbits
```
--- 

Por ahora, no entraré en detalles sobre el código ensamblador. Lo que es interesante notar en el es que el código ensamblador es relativamente fácil de leer.  porque los símbolos y funciones se han conservado. Por ejemplo, las constantes y variables tienen nombres simbólicos en lugar de sólo direcciones (incluso  si es solo un nombre generado automáticamente, como `LC0` para los sin nombre  "¡Hola Mundo!" cadena), y hay una etiqueta explícita para la función principal

Tenga en cuenta que `gcc` optimizó la llamada a `printf` reemplazándola con `puts`. 

 también es simbólico, como la referencia al “¡Hola, mundo!” `string`.
¡No hay ese lujo cuando se trata de binarios!

###  La fase de montaje

¡En la fase de ensamblaje, finalmente puedes generar código de máquina real!                                  

La entrada de la fase de ensamblaje es el conjunto de archivos en lenguaje ensamblador generados en la fase de compilación, y la salida es un conjunto de archivos objeto, a veces también denominados módulos. Los archivos objeto contienen instrucciones de máquina que, en principio, son ejecutables por el procesador. Pero como te explicaré   en un minuto, necesitará trabajar un poco más antes de tener un archivo ejecutable binario listo para ejecutar. Normalmente, cada archivo fuente corresponde a un    archivo de ensamblaje, y cada archivo de ensamblaje corresponde a un archivo de objeto. Para generar un archivo objeto, pasa el indicador `-c` a `gcc,` como se muestra.

```sh
$ gcc -c ejemplo_compilación.c
$ file ejemplo_compilación.o
```

El archivo aparece como un archivo reubicable ELF LSB de 64 bits.

¿Qué significa esto exactamente? La primera parte del resultado del archivo muestra que
El archivo cumple con la especificación ELF para ejecutables binarios (que explicaré más adelante).
se analiza en detalle más adelante). Más específicamente, que es un archivo ELF de 64 bits (ya que estás compilando para x86-64 en este ejemplo), y es ==LSB==, lo que significa que los números se ordenan en la memoria con el byte menos significativo primero. Pero
Lo más importante es que puedes ver que el archivo es reubicable.

Los archivos reubicables no dependen de que se coloquen en una dirección particular en
memoria, sino que se pueden mover a voluntad sin que esto rompa ninguna
Suposiciones en el código. Cuando vea el término reubicable en el archivo de salida,
En otras palabras, sabes que estás tratando con un archivo objeto y no con un ejecutable.
Los archivos de objeto se compilan independientemente unos de otros, por lo que el ensamblaje, no tiene forma de saber las direcciones de memoria de otros archivos de objetos cuando
ensamblar un archivo de objeto. Por eso los archivos de objeto deben ser reubicables;
De esta manera, puedes vincularlos en cualquier orden para formar un archivo binario completo.
Si los archivos de objetos no fueran reubicables, esto no sería posible.

### La fase de vinculación
La fase de vinculación es la fase final del proceso de compilación. Como indica el nombre
implica que esta fase vincula todos los archivos de objeto en un único archivo binario ejecutable.
cortable. En los sistemas modernos, la fase de enlace a veces incorpora una
Pase de optimización adicional, llamado optimización del tiempo de enlace `(LTO)⁴`
Como era de esperar, el programa que realiza la fase de enlace se llama
enlazador o editor de enlaces. Normalmente es independiente del compilador, que normalmente
Implementa todas las fases anteriores.
Como ya he mencionado, los archivos de objetos son reubicables porque son
compilados independientemente unos de otros, evitando que el compilador
suponiendo que un objeto terminará en una dirección base determinada. Más
Además, los archivos de objeto pueden hacer referencia a funciones o variables en otros archivos de objeto.
o en bibliotecas externas al programa. Antes de la fase de vinculación,
Las direcciones en las que se colocarán el código y los datos referenciados no son
aún no se conocen, por lo que los archivos de objetos solo contienen símbolos de reubicación que especifican cómo
Las referencias a funciones y variables deberían resolverse en última instancia.
Texto de enlace, las referencias que se basan en un símbolo de reubicación se denominan simbólicas.
Referencias. Cuando un archivo de objeto hace referencia a una de sus propias funciones o variables por dirección absoluta la referencia también será simbólica.
El trabajo del enlazador es tomar todos los archivos objeto que pertenecen a un programa.
y fusionarlos en un único ejecutable coherente, normalmente destinado a cargarse en una dirección de memoria particular. Ahora que la disposición de
se conocen todos los módulos del ejecutable, el enlazador también puede resolver la mayoría
referencias simbólicas. Las referencias a bibliotecas pueden o no ser completamente resuelto, dependiendo del tipo de biblioteca.

Bibliotecas estáticas (que en Linux normalmente tienen la extensión` .a`,  se fusionan en el ejecutable binario, lo que permite cualquier
referencias a ellos que se deben resolver en su totalidad. También existen dinámicas (compartidas)
bibliotecas, que se comparten en la memoria entre todos los programas que se ejecutan en un
sistema. En otras palabras, en lugar de copiar la biblioteca en cada binario
que lo utiliza, las bibliotecas dinámicas se cargan en la memoria solo una vez y cualquier
El binario que desea utilizar la biblioteca necesita utilizar esta copia compartida. Durante el
fase de enlace, las direcciones en las que residirán las bibliotecas dinámicas aún no están
conocidos, por lo que no se pueden resolver las referencias a ellos. En cambio, el enlazador deja
referencias simbólicas a estas bibliotecas incluso en el ejecutable final, y estas
Las referencias no se resuelven hasta que el binario se carga realmente en la memoria. para ser ejecutado.
La mayoría de los compiladores, incluido gcc, llaman automáticamente al enlazador al final
del proceso de compilación. Por lo tanto, para producir un ejecutable binario completo,
Puede simplemente llamar a gcc sin ningún modificador especial.

```sh
$ gcc compilation_example.c
$ file a.out
a.out:¹ELF 64-bit LSB executable, x86-64, version 1 (SYSV),²dynamically
linked,³interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32,
BuildID[sha1]=d0e23ea731bce9de65619cadd58b14ecd8c015c7,⁴not stripped
$ ./a.out
Hello, world!
```

De forma predeterminada, el ejecutable se llama `a.out`, pero puede anularlo.
Nombrar pasando el interruptor `-o`  a `gcc`, seguido de un nombre para la salida
archivo. La utilidad `file` ahora le indica que está tratando con un archivo `ELF de 64 bits. LSB ejecutable`¹, en lugar de un archivo reubicable como viste al final de la fase de ensamblaje. Otra información importante es que el archivo se `dynamically linked`², lo que significa que utiliza algunas bibliotecas que no están fusionadas en el
ejecutables, sino que se comparten entre todos los programas que se ejecutan en el mismo
sistema. Finalmente, interprete `/lib64/ld-linux-x86-64.so.2`³ en el archivo `output`
Le indica qué enlazador dinámico se utilizará para resolver las dependencias finales
en bibliotecas dinámicas cuando el ejecutable se carga en la memoria para ser ejecutado. 
Cuando ejecutas el binario (usando el comando `./a.out`), puedes ver
que produce el resultado esperado (“¡Hola, mundo!” en el formato estándar), lo que confirma que ha producido un binario funcional.
Pero, ¿qué es eso de que el binario no se “**stripped**”⁴? Lo comentaré. 

- **Symbols and Stripped Binari**
     El código fuente de alto nivel, como el código C, se centra en funciones y variables. tablas con nombres significativos y legibles para humanos. Al compilar un programa, los compiladores emiten símbolos, que mantienen un registro de dichos nombres simbólicos. código binario y datos corresponden a cada símbolo. Por ejemplo, función
     
     Los símbolos de función proporcionan una asignación de nombres de funciones simbólicas de alto nivel. a la primera dirección y el tamaño de cada función. Esta información es normal. 
     
     Generalmente lo utiliza el enlazador al combinar archivos de objetos (por ejemplo, para resolver referencias de funciones y variables entre módulos) y también ayuda a la depuración.

**Visualización de información simbólica**
Para darle una idea de cómo se ve la información simbólica muestra algunos de los símbolos en el binario de ejemplo.

```sh
readelf --syms a.out
```

He utilizado `readelf` para mostrar los símbolos. Volverá 
a utilizar la utilidad `readelf` y a interpretar toda su salida . Por 
ahora, solo observe que, entre muchos símbolos desconocidos, hay un símbolo para la función `main`. Puede ver que especifica la dirección `(0x400526)` en la que residirá `main` cuando se cargue el binario en la memoria. La salida también muestra el tamaño del código de main (32 bytes) e indica que está tratando 
con un símbolo de función `(tipo FUNC). `
La información simbólica se puede emitir como parte del binario (como acaba de ver) o en forma de un archivo de símbolos separado, y viene en varios tipos. El enlazador solo necesita símbolos básicos, pero se puede emitir información mucho más extensa para fines de depuración.  Los símbolos de depuración llegan a proporcionar un mapeo completo entre las líneas de origen y las instrucciones a nivel binario, e incluso describen parámetros de función, información del marco de pila y más. Para los binarios `ELF`, los símbolos de depuración se generan típicamente en el formato `DWARF`,5 mientras que los binarios `PE` suelen utilizar el formato propietario Microsoft Portable Debugging (PDB). La información `DWARF` suele estar 
incrustada dentro del binario, mientras que ` PDB` viene en forma de un archivo de símbolos separado. 
Como puede imaginar, la información simbólica es extremadamente útil para el análisis binario. Para nombrar solo un ejemplo, tener un conjunto de símbolos de función bien definidos a su disposición hace que el desensamblaje sea mucho más fácil porque puede usar cada símbolo de función como punto de partida para el desensamblaje. Esto hace que sea mucho menos probable que desensamble accidentalmente los datos como código, por ejemplo (lo que daría lugar a instrucciones falsas en la salida del desensamblaje).  Saber qué partes de un binario pertenecen a qué función y cómo se llama la función también hace que sea mucho más fácil para un ingeniero inverso humano compartimentar y comprender lo que está haciendo el código.

Los símbolos básicos de enlazador (en contraposición a la información de depuración más extensa) ya son de gran ayuda en muchas aplicaciones de análisis binario. 
Puede analizar símbolos con `readelf`, como mencioné anteriormente, o programáticamente con una biblioteca como `libbfd`, como explicara más adelante . También hay bibliotecas como `libdwarf` diseñadas específicamente para analizar símbolos de depuración `DWARF`, pero no las cubriré en este libro. 

Desafortunadamente, la información de depuración extensa normalmente no se incluye en binarios listos para producción, e incluso la información simbólica básica a menudo se 
elimina para reducir el tamaño de los archivos y evitar la ingeniería inversa, especialmente en el caso de malware o software propietario. Esto significa que, como analista binario, a menudo tiene que lidiar con el caso mucho más desafiante de binarios eliminados sin ningún tipo de información simbólica. Por lo tanto, a lo largo de este libro, 
asumo la menor información simbólica posible y me concentro en binarios eliminados, excepto cuando se indique lo contrario. 

# Otro binario se pasa al lado oscuro: desmantelando un binario 

Es posible que recuerdes que el binario de ejemplo aún no se ha eliminado. Aparentemente, el comportamiento predeterminado de `gcc` no es eliminar automáticamente los binarios recién compilados. En caso de que te preguntes cómo se eliminan los binarios con símbolos, es tan simple como usar un solo comando, acertadamente llamado `strip`, como se muestra. 

```sh
strip --strip-all a.out 
file a.out
```


De esta manera, el binario de ejemplo ahora se elimina ➊, como lo confirma 
la salida del archivo ➋. Solo quedan unos pocos símbolos en la tabla de símbolos `.dynsym` ➌. 
Estos se utilizan para resolver dependencias dinámicas (como referencias a bibliotecas dinámicas) cuando el binario se carga en la memoria, pero no son de mucha utilidad al desensamblar. Todos los demás símbolos, incluido el de 
la función principal que vio, han desaparecido.

# Desmontaje de un binario 

Ahora que ya has visto cómo compilar un binario, echemos un vistazo al contenido del archivo objeto producido en la fase de ensamblaje de la compilación. Después de eso, desensamblaré el ejecutable binario principal para mostrarte cómo su contenido difiere del del archivo objeto. De esta manera, obtendrás una comprensión más clara de lo que hay en un archivo objeto y lo que se agrega durante la fase de enlace.

```bash
$ ➊objdump -sj .rodata compilation_example.o

compilation_example.o: file format elf64-x86-64

Contents of section .rodata:

0000 48656c6c 6f2c2077 6f726c64 2100 Hello, world!.

$ ➋objdump -M intel -d compilation_example.o

compilation_example.o: file format elf64-x86-64

Disassembly of section .text:

0000000000000000 ➌<main>:

0: 55 push rbp

1: 48 89 e5 mov rbp,rsp

4: 48 83 ec 10 sub rsp,0x10

8: 89 7d fc mov DWORD PTR [rbp-0x4],edi

b: 48 89 75 f0 mov QWORD PTR [rbp-0x10],rsi

f: bf 00 00 00 00 mov edi,➍0x0

14: e8 00 00 00 00 ➎call 19 <main+0x19>

19: b8 00 00 00 00 mov eax,0x0

1e: c9 leave

1f: c3 ret 
```

Si observa atentamente , verá que he llamado a `objdump` dos veces. 
Primero, en ➊, le indico a `objdump` que muestre el contenido de la sección `.rodata`. Esto significa “datos de solo lectura” y es la parte del binario donde se almacenan todas las constantes, incluida la cadena “¡Hola, mundo!”. 

Que cubre el formato binario `ELF`, se analizará en detalle `.rodata` y otras secciones de los binarios `ELF`. Por ahora, observe que el contenido de `rodata` consiste en una codificación `ASCII` de la cadena, que se muestra en el lado izquierdo de la salida. En el lado derecho, puede ver la representación legible por humanos de esos mismos bytes. 
La segunda llamada a `objdump` en ➋ desensamblará todo el código en el archivo de objeto en sintaxis `Intel`. Como puede ver, solo contiene el código de la función `main` ➌ porque es la única función definida en el archivo fuente. En su mayor parte, la salida se ajusta bastante al código ensamblador producido previamente por la fase de compilación (más o menos algunas macros de nivel ensamblador). Lo que es interesante notar es que el puntero a la cadena “¡Hola, mundo!” (en ➍) está establecido en cero.  La llamada subsiguiente ➎ que debería imprimir 
la cadena en la pantalla usando `puts` también apunta a una ubicación sin sentido (desplazamiento 
19, en el medio de `main`). 

¿Por qué la llamada que debería hacer referencia a `puts` apunta en cambio al 
medio de `main`? Anteriormente mencioné que las referencias de datos y código de los 
archivos de objeto aún no están completamente resueltas porque el compilador no sabe en qué dirección base se cargará finalmente el archivo. Es por eso que la llamada a `puts` aún no está correctamente resuelta en el archivo de objeto. El archivo de objeto está esperando 
que el enlazador complete el valor correcto para esta referencia. Puede confirmar 
esto pidiéndole a `readelf` que le muestre todos los símbolos de reubicación presentes en el archivo de objeto, como se muestra 

```sh
$ readelf --relocs compilation_example.o

Relocation section '.rela.text' at offset 0x210 contains 2 entries:

Offset Info Type Sym. Value Sym. Name + Addend

➊ 000000000010 00050000000a R_X86_64_32 0000000000000000 .rodata + 0

➋ 000000000015 000a00000002 R_X86_64_PC32 0000000000000000 puts - 4 
```
El símbolo de reubicación en ➊ le indica al enlazador que debe resolver la referencia a la cadena para que apunte a la dirección en la que termina en la sección .rodata. De manera similar, la línea marcada ➋ le indica al enlazador cómo resolver la llamada a puts.

Es posible que notes que se resta el valor 4 del símbolo `puts`. 
Puedes ignorar eso por ahora; la forma en que el enlazador calcula las reubicaciones es un poco complicada y la salida readelf puede ser confusa, por lo que aquí solo pasaré por alto los detalles de la reubicación y me centraré en el panorama más amplio del desensamblado de un binario. Proporcionaré más información sobre los símbolos de reubicación más adelante. 

La columna más a la izquierda de cada línea en la salida `readelf` (sombreada)  es el desplazamiento en el archivo de objeto donde se debe completar la referencia resuelta. Si presta mucha atención, puede haber notado que en ambos 
casos, es igual al desplazamiento de la instrucción que se debe corregir, más 1. 
Por ejemplo, la llamada a `puts` está en el desplazamiento de código `0x14` en la salida `objdump`, pero el símbolo de reubicación apunta al desplazamiento `0x15`. Esto se debe a que solo desea sobrescribir el operando de la instrucción, no el código de operación de la instrucción. Resulta que para ambas instrucciones que necesitan reparación, el código de operación tiene una longitud de *1 byte*, por lo que para apuntar al operando de la instrucción, el símbolo de reubicación debe omitir el **byte** del código de operación. 
# Examinando un ejecutable binario completo

Ahora que ha visto las entrañas de un archivo de objeto, es hora de desensamblar un binario completo. Comencemos con un binario de ejemplo con símbolos y luego 
pasemos al equivalente simplificado para ver la diferencia en el resultado del desensamblado. Hay una gran diferencia entre desensamblar un archivo de objeto y 
un ejecutable binario, como puede ver en el resultado de `objdump` a continuación. 

---
```
$ objdump -M intel -d a.out

a.out: file format elf64-x86-64

Disassembly of section ➊.init:

00000000004003c8 <_init>:

4003c8: 48 83 ec 08 sub rsp,0x8

4003cc: 48 8b 05 25 0c 20 00 mov rax,QWORD PTR [rip+0x200c25]

4003d3: 48 85 c0 test rax,rax

4003d6: 74 05 je 4003dd <_init+0x15>

4003d8: e8 43 00 00 00 call 400420 <__libc_start_main@plt+0x10>

4003dd: 48 83 c4 08 add rsp,0x8

4003e1: c3 ret

Disassembly of section ➋.plt:

00000000004003f0 <puts@plt-0x10>:

4003f0: ff 35 12 0c 20 00 push QWORD PTR [rip+0x200c12]

4003f6: ff 25 14 0c 20 00 jmp QWORD PTR [rip+0x200c14]

4003fc: 0f 1f 40 00 nop DWORD PTR [rax+0x0]

0000000000400400 <puts@plt>:

400400: ff 25 12 0c 20 00 jmp QWORD PTR [rip+0x200c12]

400406: 68 00 00 00 00 push 0x0

40040b: e9 e0 ff ff ff jmp 4003f0 <_init+0x28>

...

Disassembly of section ➌.text:

0000000000400430 <_start>: 
400430: 31 ed xor ebp,ebp

400432: 49 89 d1 mov r9,rdx

400435: 5e pop rsi

400436: 48 89 e2 mov rdx,rsp

400439: 48 83 e4 f0 and rsp,0xfffffffffffffff0

40043d: 50 push rax

40043e: 54 push rsp

40043f: 49 c7 c0 c0 05 40 00 mov r8,0x4005c0

400446: 48 c7 c1 50 05 40 00 mov rcx,0x400550

40044d: 48 c7 c7 26 05 40 00 mov rdi,0x400526

400454: e8 b7 ff ff ff call 400410 <__libc_start_main@plt>

400459: f4 hlt

40045a: 66 0f 1f 44 00 00 nop WORD PTR [rax+rax*1+0x0]

0000000000400460 <deregister_tm_clones>:

...

0000000000400526 ➍<main>:

400526: 55 push rbp

400527: 48 89 e5 mov rbp,rsp

40052a: 48 83 ec 10 sub rsp,0x10

40052e: 89 7d fc mov DWORD PTR [rbp-0x4],edi

400531: 48 89 75 f0 mov QWORD PTR [rbp-0x10],rsi

400535: bf d4 05 40 00 mov edi,0x4005d4

40053a: e8 c1 fe ff ff call 400400 ➎<puts@plt>

40053f: b8 00 00 00 00 mov eax,0x0

400544: c9 leave

400545: c3 ret

400546: 66 2e 0f 1f 84 00 00 nop WORD PTR cs:[rax+rax*1+0x0]

40054d: 00 00 00

0000000000400550 <__libc_csu_init>:

...

Disassembly of section .fini:

00000000004005c4 <_fini>:

4005c4: 48 83 ec 08 sub rsp,0x8

4005c8: 48 83 c4 08 add rsp,0x8

4005cc: c3 ret
```
---
Puedes ver que el binario tiene mucho más código que el archivo de objeto. Ya no es solo la función principal o incluso una sola sección de código. Ahora hay varias secciones, con nombres como `.init` ➊, `.plt` ➋ y `.text ➌`. Todas estas secciones contienen código que cumple diferentes funciones, como la inicialización del programa o stubs para llamar a bibliotecas compartidas.

La sección `.text` es la sección de código principal y contiene la función `main`➍. También contiene otras funciones, como `_start`, que son responsables de tareas como configurar los argumentos de la línea de comandos y el entorno de ejecución 
para `main` y limpiar después de `main`. Estas funciones adicionales son funciones estándar, presentes en cualquier binario `ELF` producido por `gcc`. 
También puede ver que el enlazador ha resuelto el código y las referencias a datos que antes estaban incompletos. Por ejemplo, la llamada a `puts` ➎ 
ahora apunta al stub adecuado (en la sección `.plt`) `para` la biblioteca compartida que contiene `puts`. (Explicaré el funcionamiento de los stubs PLT más adelante ). 
Por lo tanto, el ejecutable binario completo contiene significativamente más código (y 
datos, aunque no lo he mostrado) que el archivo de objeto correspondiente. Pero hasta ahora, la salida no es mucho más difícil de interpretar.  Esto cambia cuando se desmonta el binario, como se muestra a continuación , que utiliza `objdump` para desensamblar la versión desmontada del binario de ejemplo.

```
$ objdump -M intel -d ./a.out.stripped

./a.out.stripped: file format elf64-x86-64

Disassembly of section ➊.init:

00000000004003c8 <.init>:

4003c8: 48 83 ec 08 sub rsp,0x8

4003cc: 48 8b 05 25 0c 20 00 mov rax,QWORD PTR [rip+0x200c25]

4003d3: 48 85 c0 test rax,rax

4003d6: 74 05 je 4003dd <puts@plt-0x23>

4003d8: e8 43 00 00 00 call 400420 <__libc_start_main@plt+0x10>

4003dd: 48 83 c4 08 add rsp,0x8

4003e1: c3 ret

Disassembly of section ➋.plt:

...

Disassembly of section ➌.text:

0000000000400430 <.text>:

➍ 400430: 31 ed xor ebp,ebp

400432: 49 89 d1 mov r9,rdx

400435: 5e pop rsi

400436: 48 89 e2 mov rdx,rsp

400439: 48 83 e4 f0 and rsp,0xfffffffffffffff0

40043d: 50 push rax

40043e: 54 push rsp

40043f: 49 c7 c0 c0 05 40 00 mov r8,0x4005c0

400446: 48 c7 c1 50 05 40 00 mov rcx,0x400550

40044d: 48 c7 c7 26 05 40 00 mov rdi,0x400526

➎ 400454: e8 b7 ff ff ff call 400410 <__libc_start_main@plt>

400459: f4 hlt

40045a: 66 0f 1f 44 00 00 nop WORD PTR [rax+rax*1+0x0]

➏ 400460: b8 3f 10 60 00 mov eax,0x60103f

...

400520: 5d pop rbp

400521: e9 7a ff ff ff jmp 4004a0 <__libc_start_main@plt+0x90>

➐ 400526: 55 push rbp

400527: 48 89 e5 mov rbp,rsp

40052a: 48 83 ec 10 sub rsp,0x10

40052e: 89 7d fc mov DWORD PTR [rbp-0x4],edi

400531: 48 89 75 f0 mov QWORD PTR [rbp-0x10],rsi

400535: bf d4 05 40 00 mov edi,0x4005d4

40053a: e8 c1 fe ff ff call 400400 <puts@plt>

40053f: b8 00 00 00 00 mov eax,0x0

400544: c9 leave

➑ 400545: c3 ret

400546: 66 2e 0f 1f 84 00 00 nop WORD PTR cs:[rax+rax*1+0x0]

40054d: 00 00 00

400550: 41 57 push r15

400552: 41 56 push r14

...

Disassembly of section .fini:

00000000004005c4 <.fini>:

4005c4: 48 83 ec 08 sub rsp,0x8

4005c8: 48 83 c4 08 add rsp,0x8

4005cc: c3 ret
 
```

La conclusión principal es que, si bien las diferentes secciones aún se pueden distinguir claramente (marcadas ➊, ➋ y ➌), las funciones no lo son. En cambio, todas las funciones se han fusionado en un gran blob de código. La función _START comienza en ➍ y DEREGISTER_TM_CLONES comienza en ➏. La función principal comienza en ➐ y termina en ➑, pero en todos estos casos, no hay nada especial que indique que las instrucciones en estos marcadores representan la función. Las únicas excepciones son las funciones de la sección `.plt`, que todavía tienen sus nombres como antes (como puede ver en la llamada a `__libc_start_main`en ➎). Aparte de eso, usted está solo para tratar de dar sentido a la salida del desarme. Incluso en este simple ejemplo, las cosas ya son confusas; ¡Imagínese tratar de dar sentido a un binario más grande que contiene cientos de funciones diferentes, todas juntas! Esta es exactamente la razón por la que la detección precisa de funciones automatizadas es tan importante en muchas áreas del análisis binario. 

### Cargando y ejecutando un binario 

Ahora ya sabes cómo funciona la compilación y cómo se ven los binarios en el interior. También aprendió a desmontar estáticamente binarios usando `objdump`. Si ha estado siguiendo, incluso debería tener su propio binario nuevo y brillante sentado en su disco duro. Ahora aprenderá lo que sucede cuando carga y ejecuta un binario, lo que será útil cuando discuta los conceptos de análisis dinámico en capítulos posteriores. Aunque los detalles exactos varían según la plataforma y el formato binario, el proceso de carga y ejecución de un binario generalmente implica una serie de pasos básicos. La Figura 1-2 muestra cómo se representa en la memoria un binario ELF cargado (como el que se acaba de compilar) en una plataforma basada en Linux. En un nivel alto, cargar un binario `PE` en Windows es bastante similar.

Imágenes 

Cargar un binario es un proceso complicado que implica mucho trabajo por parte del sistema operativo. También es importante tener en cuenta que la representación de un binario en la memoria no se corresponde necesariamente uno a uno con su representación en disco. Por ejemplo, las grandes regiones de datos inicializados con cero pueden colapsar en el binario en disco (para ahorrar espacio en disco), mientras que todos esos ceros ampliarse en la memoria. Algunas partes del binario en disco pueden ordenarse de manera diferente en la memoria o no cargarse en la memoria en absoluto. Debido a que los detalles dependen del formato binario, aplazo el tema de las representaciones binarias en disco versus en memoria al Capítulo 2 (en el formato `ELF`) y el Capítulo 3 (en el formato `PE`). Por ahora, sigamos con una descripción general de alto nivel de lo que sucede durante el proceso de carga. Cuando decide ejecutar un binario, el sistema operativo comienza configurando un nuevo proceso para que el programa se ejecute, incluido un espacio de direcciones virtual. Posteriormente, el sistema operativo asigna un intérprete a la memoria virtual del proceso. Este es un programa de espacio de usuario que sabe cómo cargar el binario y realizar las reubicaciones necesarias. En Linux, el intérprete suele ser una biblioteca compartida llamada `LD-Linux.so`. En Windows, la funcionalidad del intérprete se implementa como parte de `ntdll.dll`. Después de cargar el intérprete, el kernel le transfiere el control y el intérprete comienza su trabajo en el espacio del usuario. Los binarios de Linux ELF vienen con una sección especial llamada `.interp ` que especifica la ruta al intérprete que se va a utilizar para cargar el binario, como puede ver con `readEelf`. 

```
$ readelf -p .interp a.out

String dump of section '.interp':

[ 0] /lib64/ld-linux-x86-64.so.2 
```

Como se mencionó, el intérprete carga el binario en su espacio de direcciones virtual (el mismo espacio en el que se carga el intérprete). Luego analiza el binario para averiguar (entre otras cosas) qué bibliotecas dinámicas usa el binario. El intérprete los mapea en el espacio de direcciones virtuales (usando `MMAP` o una función equivalente) y luego realiza las reubicaciones de último minuto necesarias en las secciones de código del binario para completar las direcciones correctas para referencias a las bibliotecas dinámicas. En realidad, el proceso de resolución de referencias a funciones en las bibliotecas dinámicas a menudo se difiere hasta más tarde. En otras palabras, en lugar de resolver estas referencias inmediatamente en el momento de la carga, el intérprete resuelve las referencias solo cuando se invocan por primera vez. Esto se conoce como enlace Lazy, que explicaré con más detalle en el Capítulo 2. Después de completar la reubicación, el intérprete busca el punto de entrada del binario y le transfiere el control, comenzando la ejecución normal del binario.

          **Resumen**
Ahora que está familiarizado con la anatomía general y el ciclo de vida de un binario, es hora de profundizar en los detalles de un formato binario específico. Comencemos con el formato ELF generalizado, que es el tema del próximo capítulo.
          **Ejercicios 1.**
Funciones de localización Escriba un programa C que contenga varias funciones y compile en un archivo de ensamblaje, un archivo de objeto y un binario ejecutable, respectivamente. Intente localizar las funciones que escribió en el archivo de ensamblaje y en el archivo de objeto y en el archivo de objeto desarmado. ¿Puedes ver la correspondencia entre el código C y el código de ensamblaje? Finalmente, pele el ejecutable e intente identificar las funciones nuevamente. 

**Las secciones**

Como ha visto, los binarios ELF (y otros tipos de binarios) se dividen en secciones. Algunas secciones contienen código y otras contienen datos. ¿Por qué crees que existe la distinción entre código y secciones de datos? ¿En qué cree que difiere el proceso de carga para las secciones de código y datos? ¿Es necesario copiar todas las secciones en la memoria cuando se carga un binario para su ejecución?

#  2. El formato ELF 

Ahora que tiene una idea de alto nivel de cómo se ven los binarios y cómo funcionan, está listo para sumergirse en un formato binario real. En este capítulo, investigará el formato ejecutable y vinculable (ELF), que es el formato binario predeterminado en los sistemas basados en Linux y el que trabajará en este libro. ELF se utiliza para archivos ejecutables, archivos de objetos, bibliotecas compartidas y volcados de núcleo. Me centraré en los ejecutables ELF aquí, pero los mismos conceptos se aplican a otros tipos de archivos ELF. Debido a que tratará principalmente con binarios de 64 bits en este libro, centraré la discusión en archivos ELF de 64 bits. Sin embargo, el formato de 32 bits es similar, y difiere principalmente en el tamaño y el orden de ciertos campos de encabezado y otras estructuras de datos. No debería tener problemas para generalizar los conceptos discutidos aquí a los binarios ELF de 32 bits. La Figura 2-1 ilustra el formato y el contenido de un ejecutable ELF típico de 64 bits. Cuando comienzas a analizar en detalle los binarios de ELF, todas las complejidades involucradas pueden parecer abrumadoras. Pero en esencia, los binarios ELF realmente consisten en solo cuatro tipos de componentes: un encabezado ejecutable, una serie de encabezados de programa (opcionales), una serie de secciones y una serie de encabezados de sección (opcionales), uno por sección. A continuación, discutiré cada uno de estos componentes.

Imagen 

Como puede ver en la Figura 2-1, el encabezado ejecutable es lo primero en los binarios de ELF estándar, los encabezados del programa vienen a continuación y las secciones y los encabezados de las secciones son los últimos. Para que la siguiente discusión sea más fácil de seguir, usaré un orden ligeramente diferente y discutiré las secciones y los encabezados de las secciones antes de los encabezados del programa. Comencemos con el ejecutable `header`.


## El `header`

Cada archivo ELF comienza con un `header` , que es solo una serie estructurada de bytes que le dice que es un archivo ELF, qué tipo de archivo ELF es y dónde en el archivo para encontrar todos los demás contenidos. Para averiguar cuál es el formato del encabezado ejecutable, puede buscar su definición de tipo (y las definiciones de otros tipos y constantes relacionados con ELF) en `/usr/include/elf.h` o en la especificación ELF.1 Listado 2-1 Muestra la definición de tipo para el encabezado ex-e-Cuttable de ELF de 64 bits.



#### Referencia 
https://thelinuxcode.com/understanding_elf_file_format/
https://bottomupcs.com/ch08.html#executable_files




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
{% endif %}by
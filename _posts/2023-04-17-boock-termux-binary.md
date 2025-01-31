### ¿Qué es el análisis binario y por qué lo necesita?

.......?

- **Análisis estático** 
    Las técnicas de análisis estático  sobre un binario sin  ejecutándolo. Este enfoque tiene varias ventajas: potencialmente puedes   analiza todo el binario de una sola vez y no necesitas una CPU que pueda ejecuta el binario. Por ejemplo, puedes analizar estáticamente un binario `ARM` en una máquina `x86`. La desventaja es que el análisis estático no tiene conocimiento del estado de ejecución del binario, lo que puede hacer que el análisis sea muy complicado y desafiante.
    
- **Análisis dinámico**                                          
    - Por el contrario, el análisis dinámico ejecuta el binario y lo analiza a medida que se ejecuta. Este enfoque suele ser más simple que el análisis estático.                                     porque tiene pleno conocimiento de todo el estado de ejecución, incluido los valores de las variables y los resultados de las ramas condicionales. 

#### **Sintaxis de ensamblaje**       
Existen dos formatos de sintaxis populares que se utilizan para   representar instrucciones de máquina `x86`: sintaxis `Intel` y sintaxis `AT&T`. aquí voy a   Utilice la sintaxis `Intel` porque es menos detallada. 

En la sintaxis de `Intel`, mover una constante   en el registro *edi* se ve así:                                  

```c
mov   edi,0x6
```


## Proceso de computación **C**

Los binarios se producen mediante compilación, que es el proceso de traducir código fuente legible por humanos, como C o C++, a código de máquina que su procesador puede ejecutar la Figura 1-1 muestra los pasos involucrados en un proceso típico
proceso de compilación para código C (los pasos para la compilación de C++ son similares).                            
La compilación de código C implica cuatro fases, una de las cuales (por extraño que parezca) es
También se llama compilación, al igual que el proceso de compilación completo. Las fases son
==preprocesamiento, compilación, ensamblaje y vinculación==. En la práctica, los compiladores modernos  a menudo fusionamos algunas o todas estas fases, pero para fines de demostración,  los cubriremos todos por separado.

imagen 1-1 

### La fase de preprocesamiento

El proceso de compilación comienza con una cantidad de archivos fuente que desea   para compilar (que se muestra como archivo-1.c a archivo-n.c en la Figura 1-1). Es posible   tener un solo archivo fuente, pero los programas grandes ge
neralmente se componen de muchos                           archivos. Esto no sólo hace que el proyecto sea más fácil de gestionar, sino que también acelera la compilación porque si un archivo cambia, solo tienes que volver a compilar ese archivo   en lugar de todo el código.                            
Los archivos fuente C contienen macros (indicadas por` #define`) y directivas `#include`. Utilice las directivas `#include` para incluir archivos de encabezado (con la extensión .h) de los que depende el archivo fuente. La fase de preprocesamiento se expande   cualquier directiva `#define` y `#include` en el archivo fuente, por lo que todo lo que queda es C puro Código listo para ser compilado.                          
Hagamos esto más concreto mirando un ejemplo. este ejemplo utiliza el compilador *gcc*, que es el predeterminado en muchas distribuciones de Linux


- *ejemplo_compilacion.c*
```c
#include <stdio.h>

#define STRING_FORMAT "%s"
#define MESSAGE       "Hello World\n" 

int mein(int argc, char argv[]){
  printf(STRING_FORMAT,MESSAGE);
  return 0;
}
```

De forma predeterminada, `gcc` ejecutará automáticamente toda la fases de compilación, por lo que debe indicarle explícitamente que se detenga después del preprocesamiento y que muestre             usted la salida intermedia. Para `gcc,` esto se puede hacer usando el comando     `gcc -E -P`, donde `-E` le dice a **gcc** que se detenga después del preprocesamiento y `-P` provoca que  el compilador omita la información de depuración para que la salida sea un poco más limpia.

###  La fase de compilación       
Una vez completada la fase de preprocesamiento, el código fuente está listo para ser compilado. La fase de compilación toma el código preprocesado y lo traduce.   A lenguaje ensamblador. (La mayoría de los compiladores también realizan una gran optimización en  esta fase, normalmente configurable como un nivel de optimización mediante comando   conmutadores de línea como las opciones `-O0` a `-O3` en `gcc`. Como verá más adelante el grado de optimización durante la compilación puede tener un profundo impacto y   efecto en el desmontaje.)       

**¿Por qué la fase de compilación produce lenguaje ensamblador y no?¿código máquina? **

Esta decisión de diseño no parece tener sentido en el contexto de un solo lenguaje (en este caso, C), pero sí lo tiene cuando se piensa en   todos los demás idiomas que existen. Algunos ejemplos de lenguajes compilados populares incluyen `C`, `C++`, `Objective-C`, `Common Lisp`, `Delphi`, `Go` y `Haskell`.

Como se mencionó, gcc  normalmente llama a todas las fases de compilación automáticamente, por lo que para ver el archivo emitido   ensamblaje desde la etapa de compilación, debes decirle a gcc que se detenga después de esto   etapa y almacenar los archivos de ensamblaje en el disco. Puedes hacer esto usando el indicador `-S`   (.s es una extensión convencional para archivos de ensamblaje). También pasas la opción.  `-masm=intel` a gcc para que emita ensamblado en sintaxis Intel           

---
```sh
$ gcc -S -masm=intel ejemplo_compilacion.c
$ cat compilation_example.s
.file"ejemplos_compilacion.c"
.intel_syntax noprefix
.section.rodata
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

2. Tenga en cuenta que `gcc` optimizó la llamada a `printf` reemplazándola con `puts`. 

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
Pero, ¿qué es eso de que el binario no se “stripped”⁴? Lo comentaré. 

- **Symbols and Stripped Binari**
     El código fuente de alto nivel, como el código C, se centra en funciones y variables. tablas con nombres significativos y legibles para humanos. Al compilar un programa, los compiladores emiten símbolos, que mantienen un registro de dichos nombres simbólicos. código binario y datos corresponden a cada símbolo. Por ejemplo, función
     
     Los símbolos de función proporcionan una asignación de nombres de funciones simbólicas de alto nivel. a la primera dirección y el tamaño de cada función. Esta información es normal. 
     
     Generalmente lo utiliza el enlazador al combinar archivos de objetos (por ejemplo, para resolver referencias de funciones y variables entre módulos) y también ayuda a la depuración.

**Visualización de información simbólica**
Para darle una idea de cómo se ve la información simbólica muestra algunos de los símbolos en el binario de ejemplo.

```sh
readelf --syms a.out
```

#### Referencia 

https://bottomupcs.com/ch08.html#executable_files
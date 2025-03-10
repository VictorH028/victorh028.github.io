
## **Introducción a Smali**
Smali es la representación textual de los archivos DEX, que son ejecutados por la máquina virtual Dalvik (o ART en versiones más recientes de Android). Aprender Smali te permitirá:
- Modificar aplicaciones Android.
- Analizar el comportamiento de apps.
- Realizar parches o mejoras en apps existentes.

---

## Encabezado de clase

Cada archivo Smali comienza con la definición de la clase, de la siguiente manera :

```r
.class <public|private|synthetic> <static?> L<path>/<class_name>; 
# el nombre de la clase podría ser: "Test" para el archivo Test.smali 
# Si Test tiene una clase anidada "nestedTest", el nombre podría ser "Test$nestedTest" 

.super L<parent_class>; 
# Como en Java, la madre de todas las clases es java/lang/Object;   
```

Para definir un método:

```r
# definición de un método: 
# el método puede ser privado / protegido / público 
# Se puede llamar de forma estática o debe ser instanciado, si el método es estático, la clase debe ser estática 

.method <public|private> <static?> <function_name> ( <type> ) <return_type> 
# .locals definirá la cantidad de registros a utilizar 
# .locals 3 le permite usar v0, v1 y v2
.locals <X>   


# En función del tipo de retorno el método podría ser fin: 
# Si el tipo de retorno es V (void)
return-void

# Si el tipo de retorno es tipos nativos: 
return <register> 
# Donde el registro contiene el tipo de retorno correcto 


# Si el tipo de retorno es un objeto 
return-object <register> 

# Finalmente un método siempre termina con: 
.end method
```

Otras directivas opcionales pueden ser `.implements`, `.debug`,`.source`


---

#  Decriptores de tipo

Los tipos nativos son los siguientes: 
- `V` void
- `Z` boolean
- `B` byte
- `S` short
- `C` char
- `I` int
- `J` long (64 bit)
- `F` float
- `D` double (64 bit) 

---

## **Herramientas necesarias**
- **Apktool**: Herramienta para descompilar y recompilar archivos APK.
- **Jadx**: Descompilador de Java para ver el código fuente de las apps.
- **Bytecode Viewer**: Herramienta para visualizar Smali y Java.
- **Android Studio**: Para probar y depurar aplicaciones.
- **d8**:  
- **dex2jar**:

---

# Registro 

Los registros se usan para almacenar valores temporales

- **Registros locales ( Vx)**: se utilizan para variables locales y valores temporales. `V0`, `V1`
- **Registros de parámetros ( Px)** : se utilizan para pasar parámetros en funciones, `P0` normalmente representan al `this` operador. 

| Dominio                  | Descripción                                                                                                                    | Ejemplo (Java, smali)                                                       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| `move y, x`              | Mueve el contenido de x a y                                                                                                    | `int a = 12; move v0, 0xc`                                                  |
| `const/4 x, list4`       | Coloca la constante de 4 bits en `x`. El valor máximo es `7`. Para valores más altos, elimine `/4` para usar `const x, value`. | `int level = 3;<br>const/4 v0, 0x5 `                                        |
| `new-array x,y,type_id ` | Genera una nueva matriz de `type_id` tipo y `y` tamaño de elemento, luego almacena la referencia en `x`.                       | `byte[] bArr = {0, 1, 2, 3, 4};<br>const/4 v0, 0x5<br>new-array v0, v0, [B` |
| `const x, lit32 `        | Pone una referencia a una constante de cadena identificada por `string_id` en `x`.                                             | `String name = "Player";<br>const-string v5, "Player" `                     |
 
--- 

### Operaciones matemáticas en Smali

| Operación      | Instrucción Smali | Ejemplo              |
| -------------- | ----------------- | -------------------- |
| Suma           | `add-int`         | `add-int v0, p0, p1` |
| Resta          | `sub-int`         | `sub-int v3, v0, v1` |
| Multiplicación | `mul-int`         | `mul-int v0, p0, p1` |
| División       | `div-int`         | `div-int v0, p0, p1` |
| Módulo         | `rem-int`         | `rem-int v0, p0, p1` |

---
## Métodos - Objetos

####  Invocación de método 
Se utilizan diferentes instrucciones dependiendo de si se invoca un método de forma estática, virtual o en una interfaz.

- **invoke-virtual**: Llama a un método en una instancia de objeto (método público).

- **invoke-static**:Llama a un método estático.

* **invoke-direct**:Llama a un método en el objeto actual directamente (privado) (normalmente constructores).

## Ejemplo 

```r
invoke-static {}, Ljava/lang/System;->gc()V  
# Invoca el método estático 'gc' de la clase Sistema
``` 

```r
invoke-virtual {v0}, Ljava/lang/String;->length()I   # Llamar al método length() en un objeto String almacenado en v0
``` 

Tabla que resume los comandos y las descripciones para invocar métodos en Java/Smali:


| Domonio | Descripción  | Ejemplo  |
| ------- | ----------- | -------- |
|         |              |          |


--- 
# Ejemplo practicos

#### **Estructura básica de Smali**

Vamos a comenzar con un ejemplo básico de `Java` y lo vamos a convertir a `smali`

```java
package com.app.smali1;
public class HolaMundo{
    public static void HolaMundoFuncion(){
         System.out.println("Hola Mundo");
    };
public  static  void  main(String[] argv){
    HolaMundoFuncion();
}}
```

## Compilasion a DEX
Compilamos de  *java* a `.class` y después a `.dex`.

```shell 
javac -g HolaMundo.java
d8 HolaMundo.class --output ./
```

## Desamblo a Smali 

>>**Nota**: _Estoy usando `termux` y existe métodos más fáciles de pasar el código a smali 😁.  Uso `apkmod` por comodidad_

```shell 
zip  HolaMundo.apk classes.dex
apkmod -d -i  HolaMundo.apk  -o HolaMundo
```

Dentro de la carpeta encontrarás

```shell 
HolaMundo
├── apktool.yml
├── original
└── smali
    └── com
        └── app
            └── smali1
                └── HolaMundo.smali 
```


**Contenido**:

```r
.class public Lcom/app/smali1/HolaMundo;
.super Ljava/lang/Object;
.source "HolaMundo.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static HolaMundoFuncion()V
    .locals 2

    .line 4
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v1, "Hola Mundo"

    invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 5
    return-void
.end method

.method public static main([Ljava/lang/String;)V
    .locals 0
    .param p0, "argv"    # [Ljava/lang/String;

    .line 7
    invoke-static {}, Lcom/app/smali1/HolaMundo;->HolaMundoFuncion()V

    .line 8
    return-void
.end method 
```

## Explicasion 

**Declaración de la clase**

```r
.class public Lcom/app/smali1/HolaMundo;
.super Ljava/lang/Object;
.source "HolaMundo.java" 
```

-  `.class` define la clase `HolaMundo`
- `super` indica que la clase  hereda de`Object`
- `.source ` Es el archivo fuente original 

###  **Contructor**
```r
.method public constructor <init>()V
       .locals 0

       .line 2
       invoke-direct {p0}, Ljava/lang/Object;-><init>()V

       return-void
   .end method
```

- `<init>` es el constructor de la clase 
- `invoke-direct ` llama al constructor de la super clase (`Opject`)
- `p0` Es una referencia a el objeto actual 
- `return-void` Indica que el constructor no devuelve ningún valor

### **Método `HolaMundoFuncion`**

```r
.method public static HolaMundoFuncion()V
       .locals 2

       .line 4
       sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

       const-string v1, "Hola Mundo"

       invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

       .line 5
       return-void
   .end method
```

 -  `.method public static HolaMundoFuncion()V` Define el método  (`V` si unifica `void`)
   - `sget-object` carga el objeto `System.out` en el registro `v0`.
   - `const-string` carga la cadena "Hola, Mundo!" en el registro `v1`.
   - `invoke-virtual` llama al método `println` en el objeto `PrintStream` (que es `System.out`). 
### **Método `main`**

```r
.method public static main([Ljava/lang/String;)V
       .locals 0
       .param p0, "argv"    # [Ljava/lang/String;

       .line 7
       invoke-static {}, Lcom/app/smali1/HolaMundo;->HolaMundoFuncion()V

       .line 8
       return-void
   .end method 
```

  - `.method public static main([Ljava/lang/String;)V`: Define el método `main`, que es el punto de entrada del programa. Toma un array de cadenas (`[Ljava/lang/String;`) como argumento y no devuelve ningún valor.
   - `invoke-static {}, Lcom/app/smali1/HolaMundo;->HolaMundoFuncion()V`: Llama al método estático `HolaMundoFuncion` definido anteriormente.

---

# Operaciones matemática

```r
public class Operaciones {
    public static int suma(int a, int b){
        return a + b;
    }

    public static void main(String[] args) {
        // Declaración de variables
        int a = 10;
        int b = 5;

        // Operaciones
        int suma = suma(a,b);
        int resta = a - b;

        // Imprimir resultados
        System.out.println("Suma: " + suma);
        System.out.println("Resta: " + resta);
    }
}
```

###  Código `smali`

```r
.class public LOperaciones;
.super Ljava/lang/Object;
.source "Operaciones.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static main([Ljava/lang/String;)V
    .locals 7
    .param p0, "args"    # [Ljava/lang/String;

    .line 8
    const/16 v0, 0xa

    .line 9
    .local v0, "a":I
    const/4 v1, 0x5

    .line 12
    .local v1, "b":I
    invoke-static {v0, v1}, LOperaciones;->suma(II)I

    move-result v2

    .line 13
    .local v2, "suma":I
    sub-int v3, v0, v1

    .line 16
    .local v3, "resta":I
    sget-object v4, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Suma: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 17
    sget-object v4, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Resta: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 18
    return-void
.end method

.method public static suma(II)I
    .locals 1
    .param p0, "a"    # I
    .param p1, "b"    # I

    .line 3
    add-int v0, p0, p1

    return v0
.end method
```

---

###  **Suma (`+`)**

 Método `suma`:

```r
.method public static suma(II)I
    .locals 1
    .param p0, "a"    # I
    .param p1, "b"    # I

    .line 3
    add-int v0, p0, p1

    return v0
.end method
```

  - **`add-int v0, p0, p1`**: Esta es la instrucción que realiza la suma.
  - `add-int`: Es la instrucción que suma dos valores enteros.
  - `v0`: Es el registro donde se almacenará el resultado de la suma.
  - `p0` y `p1`: Son los registros que contienen los valores de los parámetros `a` y `b` respectivamente.
  - El resultado de `p0 + p1` se almacena en `v0`, que luego se devuelve con `return v0`.

---

### **Resta (`-`)**

La resta se realiza directamente en el método `main`:

```smali
sub-int v3, v0, v1
```

  - **`sub-int v3, v0, v1`**: Esta es la instrucción que realiza la resta.
  - `v3`: Es el registro donde se almacenará el resultado de la resta.
  - `v0` y `v1`: Son los registros que contienen los valores de las variables `a` y `b` respectivamente.

---

### **Llamada al método `suma`**

En el método `main`, se llama al método `suma` para realizar la suma:

```smali
invoke-static {v0, v1}, LOperaciones;->suma(II)I
move-result v2
```

- **`invoke-static {v0, v1}, LOperaciones;->suma(II)I`**: Llama al método estático `suma` con los valores de `v0` y `v1` como argumentos.
- **`move-result v2`**: Almacena el resultado de la suma en el registro `v2`.

---

# IF - ELSE - GOTO 

Comparación con 0

| Sintaxis             | Descripción                    |
| -------------------- | ------------------------------ |
| `if-eqz x, target`   | Salta a `target ` si `x==0`    |
| `if-nez x, target`   | Salta a `target ` si `x!=0`    |
| `if-ltz x, target`   | Salta a `target` si `x < 0`    |
| `if-gez x, target `  | Salta a `target` i `x >= 0`    |
| `if-gtz x, target `  | Salta a `target` si `x > 0`    |
| `if-lez x, target `  | Salta a `target`  si `x <= 0 ` |

# Comparación con un registro 

| Sintaxis           | Descripción                    |
| ------------------ | ------------------------------ |
| `if-eq x, v, target`  | Salta a `target ` si `x == v`  |
| `if-ne x, v, target`  | Salta a `target ` si `x != v`  |
| `if-lt x, v, target`  | Salta a `target`  si `x < v`   |
| `if-ge x, v, target ` | Salta a `target`  si `x >= v`  |
| `if-gt x, v, target ` | Salta a `target`  si `x > v`   |
| `if-le x, v, target ` | Salta a `target`  si `x <= v ` |

# Ir A

| Dominio | Descripción  | Ejemplo(Java, smali ) |
| ------- | ----------- | --------------------- |
|         |              |                       |




--- 



---

# Trucos en `SMALI`



---

# **Como aplicar parchos**



---



## Obtener/Guardar atributos de un objeto  

`iget v0, p0, Lcom/ams/gametest/model/Game;->level:I #Guarda this.level dentro de v0`
`iput v0, p0, Lcom/ams/gametest/model/Game;->level:I #Guarda v0 dentro de this.level`
  


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

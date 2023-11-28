---
comments: true
layout: single
title: Resaltado de sintaxis en C++ 
date: 2023-07-5
classes: wide
header:
  teaser: /assets/images/
  teaser_home_page: true
categories:
  - Programacion
tags:
  - termux 
  - linux
---

Esto es un pequeño ejemplo de como crear un resaltado de sintaxis en C++ 



```cpp
#include <iostream >


enum 
class Color 
{
 Default,
 Black,
 Red,
 Green,
 Yellow,
 Blue,
 Magenta,
 Cyan,
 White
};

std::string 
setColor(Color color);

void 
syntax_highlight(const std::string &code);  




Int 
main() {

return 0;
} 

std::string 
setColor(Color color) {
 std::string code = "\033[";
 switch (color) {
        case Color::Default:
            code += "0";
            break;
        case Color::Black: // Negro
            code += "30";
            break;
        case Color::Red:   // Rojo
            code += "31";
            break;
        case Color::Green: // Verde
            code += "32";
            break;
        case Color::Yellow:// Amarillo
            code += "33";
            break;
        case Color::Blue:  // Azul
            code += "34";
            break;
        case Color::Magenta:// Magenta
            code += "35";
            break;
        case Color::Cyan:  // cian
            code += "36";
            break;
        case Color::White: // Blanco 
            code += "37";
            break;
        default:
            code += "0";
    }

    code += "m";
    return code;
}; 


void 
syntax_highlight(const std::string &code){
    std::string highlightedCode = "";
    // Colores para cada parte del código
    std::string colorKeywords = setColor(Color::Blue);
    std::string colorStrings = setColor(Color::Green);
    std::string colorComments = setColor(Color::Magenta);
    std::string colorDefault = setColor(Color::Default);

    std::size_t pos = 0;
    std::size_t start = 0;
    std::size_t end = 0;

    while (pos < code.size()) {
        // Buscar en la cadena 
        if (code.find("#", pos) == pos) {
            // Comentario
            start = pos;
            end = code.find("\n", pos);
            // Si no hay coincidencias
            if (end == std::string::npos) {
                end = code.size();
            }
            pos = end;
            highlightedCode += colorComments + code.substr(start, end - start) + colorDefault;
        } else if (std::isalpha(code[pos])) {
            // Palabra clave
            start = pos;
            while (std::isalnum(code[pos]) || code[pos] == '_') {
                pos++;
            }
            std::string keyword = code.substr(start, pos - start);
            highlightedCode += colorKeywords + keyword + colorDefault;
        } else if (code[pos] == '"' || code[pos] == '\'') {
            // Cadena de caracteres
            char delimiter = code[pos++];
            start = pos;
            while (pos < code.size() && code[pos] != delimiter) {
                pos++;
            }
            if (pos < code.size()) {
                pos++;
            }
            std::string str = code.substr(start, pos - start);
            highlightedCode += colorStrings + str + colorDefault;
        } else {
            // Otros caracteres
            highlightedCode += code[pos++];
        }
    }
    std::cout << highlightedCode << std::endl;
};
```






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





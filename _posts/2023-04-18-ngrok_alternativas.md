---
layout: single
title: Alternativas para `ngrok`
date: 2023-04-18
classes: wide
header:
  teaser: /assets/images/ngrok/ngrok-blue.png
  teaser_home_page: true
categories:
  - alternativa
tags:
  - termux
  - tips
---


Ngrok es una aplicación desarrollada por Alan Shreeve , permite a los desarrolladores exponer sus servidores de desarrollo locales a Internet. Básicamente, crea un túnel a su servidor de desarrollo local y genera dos subdominios aleatorios en ngrok.com, uno http y otro con https pero en ocasiones tenemos problemas con dicho servicio y por eso le brindo otras formas de lograr o optener el mismo resultado 

# Opcion 1
```bash
https://pagekite.net
curl -O https://pagekite.net/pk/pagekite.py 
python2 pagekite.py 80 yourname.pagekite.me
```
# Opcion 2
```
https://portmap.io
```

# Opcion 3
```
https://github.com/antoniomika/sish
```

# Opcion 4
```
https://forwardhq.com
```

# Opcion 5
```
https://www.beame.io
```

# Opcion 6
```
https://localhost.run
```

# Opcion 7
```
https://holepunch.io
```

# Opcion 8

```
https://burrow.io
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



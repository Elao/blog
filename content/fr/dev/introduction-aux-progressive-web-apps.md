---
type:           "post"
title:          "Progressive web apps"
date:           "2016-12-05"
publishdate:    "2016-12-05"
draft:          false
slug:           "introduction-aux-progressive-web-apps"
description:    ""
language:       "fr"
thumbnail:      "/images/posts/2016"
header_img:     "/images/posts/2016"
tags:           ["service workers", "web", "mobile"]
categories:     ["dev"]

author_username: "rhanna"

---

En 2010, le magazine américain Wired titrait "[The web is dead](https://www.wired.com/2010/08/ff_webrip/)"
les apps allait remplacé le web.
En 2014, retournement de veste [The web is not dead](https://www.wired.com/insights/2014/02/web-dead/)
L'installation d'apps n'a pas pris le dessus sur l'utilisation du web
En réalité la plupart des gens [n'utilisent que très peu d'apps](http://www.recode.net/2016/6/8/11883518/app-boom-over-snapchat-uber), celles des messageries et des réseaux sociaux.

https://addyosmani.com/blog/getting-started-with-progressive-web-apps/

Progressive Web Apps

- Amélioration progressive : fonctionne pour n'importe quel utilisateur quel que soit le navigateur utilisé

Stratégies pour la gestion du cache : Jake Archibald, un des ingénieurs de Google [The offline cookbook](https://jakearchibald.com/2014/offline-cookbook/)

## Outils

- [Service Worker Precache](https://github.com/GoogleChrome/sw-precache/) un module node pour faciliter la gestion de la mise en cache des ressouces statiques (HTML, JavaScript, CSS, images, etc.) via les Service Worker. Un [codelab](https://codelabs.developers.google.com/codelabs/sw-precache/index.html) est disponible.
- [Service Worker Toolbox](https://github.com/GoogleChrome/sw-toolbox)

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

La plupart des liens de cet article vont vers des sites Google ou des blogs des ingénieurs de chez Google,
tout simplement parce que les contenus sont de qualité.
Cela s'explique car le mastondonte américain fait un lobby de dingue pour pousser les Progressive web apps et faire plier son rival Apple, qui est en retard en la matière.
Et honnêtement, ils n'ont pas tout à fait tord. Voici pourquoi.

Il existait déjà une technologie permettant de gérer du cache dans le navigateur et gérer du hors-ligne : [Application Cache](https://developer.mozilla.org/fr/docs/Web/HTML/Utiliser_Application_Cache) mais cette technologie est dépréciée au profit des [Services Workers](https://developer.mozilla.org/fr/docs/Web/API/Service_Worker_API/Using_Service_Workers).

https://addyosmani.com/blog/getting-started-with-progressive-web-apps/

Progressive Web Apps

- Amélioration progressive : fonctionne pour n'importe quel utilisateur quel que soit le navigateur utilisé. Seuls les navigateurs modernes (comprendre Chrome et Firefox) profiteront de toutes les possibilités.
- Responsive : s'ajuste à la taille de l'écran, sur ordinateur, mobile ou tablette.
- Indépendant de la connexion : expérience améliorée grâce aux service workers qui permettent à l'application de fonctionner hors connexion ou en très bas débit.
- 
App-like - Use the app-shell model to provide app-style navigations and interactions.
Fresh - Always up-to-date thanks to the service worker update process.
Safe - Served via TLS to prevent snooping and ensure content hasn’t been tampered with.
Discoverable - Are identifiable as “applications” thanks to W3C manifests and service worker registration scope allowing search engines to find them.
Re-engageable - Make re-engagement easy through features like push notifications.
Installable - Allow users to “keep” apps they find most useful on their home screen without the hassle of an app store.
Linkable - Easily share via URL and not require complex installation.

Comparaison taille webapp / app native

Des retours assez impressionnants :

- [AliExpress](https://developers.google.com/web/showcase/2016/aliexpress) : 104% de nouveaux utilisateurs quelque soit le navigateur utilisé ; 82% de hausse du taux de conversion des utilisateurs iOS,
- [eXtra Electronics](https://developers.google.com/web/showcase/2016/extra) : 100% d'augmentation des ventes avec les Web Push Notifications,
- [Jumia](https://developers.google.com/web/showcase/2016/jumia) : 9 fois plus de conversions de paniers abandonnés avec les Web Push Notifications,
- [5miles](https://developers.google.com/web/showcase/2016/5miles) : 30% de hausse de la conversion des utilisateurs qui passent par l'app placée en écran d'accueil.
                                                                     


Stratégies pour la gestion du cache : Jake Archibald, un des ingénieurs de Google [The offline cookbook](https://jakearchibald.com/2014/offline-cookbook/)

## Ajout d'un site à l'écran d'accueil Web App Manifest

Le Web App Manifest a pour but d'installer des applications Web sur l'écran d'accueil d'un appareil, notamment les smartphone, offrant aux utilisateurs un accès plus rapide.

https://developers.google.com/web/fundamentals/engage-and-retain/web-app-manifest/

## Push Notifications

https://developers.google.com/web/fundamentals/getting-started/codelabs/push-notifications/
https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/

## Outils

- [Service Worker Precache](https://github.com/GoogleChrome/sw-precache/) un module node pour faciliter la gestion de la mise en cache des ressouces statiques (HTML, JavaScript, CSS, images, etc.) via les Service Worker. Un [codelab](https://codelabs.developers.google.com/codelabs/sw-precache/index.html) est disponible.
- [Service Worker Toolbox](https://github.com/GoogleChrome/sw-toolbox)
- [Lighthouse](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk)

https://jakearchibald.github.io/isserviceworkerready/

Safari ?
[Under Consideration](https://webkit.org/status/#specification-service-workers)

[Wikipedia offline demo](https://wiki-offline.jakearchibald.com/) est une démo montant les possibilités de concevoir les applications en "offline-first". A tester don 



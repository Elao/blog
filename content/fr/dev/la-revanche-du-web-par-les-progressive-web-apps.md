---
type:           "post"
title:          "Le web n'est pas mort, la revanche par les Progressive web apps"
date:           "2016-12-05"
publishdate:    "2016-12-05"
draft:          false
slug:           "la-revanche-du-web-par-les-progressive-web-apps"
description:    "Les Progressives Web Apps rivalisent avec les apps natives. Voyons l'intérêt que cela peut apporter à vos utilisateurs et... à vous."
language:       "fr"
thumbnail:      "/images/posts/2016"
header_img:     "/images/posts/2016"
tags:           ["service workers", "web", "mobile"]
categories:     ["dev"]

author_username: "rhanna"

---

En 2010, le magazine américain Wired titrait "[The web is dead](https://www.wired.com/2010/08/ff_webrip/)"
et prédisait que les apps allait remplacé le web.
En 2014, retournement de veste [The web is not dead](https://www.wired.com/insights/2014/02/web-dead/).
L'installation d'apps n'a finalement pas pris le dessus sur l'utilisation du web.
En réalité la plupart des gens [n'utilisent que très peu d'apps](http://www.recode.net/2016/6/8/11883518/app-boom-over-snapchat-uber), celles des messageries et des réseaux sociaux.

La plupart des liens de cet article vont vers des sites Google ou des blogs des ingénieurs de chez Google,
tout simplement parce que les contenus sont de qualité.
Cela s'explique car le mastondonte américain fait un lobby de dingue pour pousser les Progressive web apps et faire plier son rival Apple, qui est en retard en la matière.
Et honnêtement, ils n'ont pas tout à fait tord. Voici pourquoi.

## Qu'est ce qu'une Progressive Web App ?

- Amélioration progressive : le site fonctionne pour n'importe quel utilisateur quel que soit le navigateur utilisé. Seuls les navigateurs modernes (comprendre Chrome et Firefox) profiteront de toutes les possibilités.
- Responsive : s'ajuste à la taille de l'écran, sur ordinateur, mobile ou tablette.
- Indépendant de la connexion : expérience améliorée grâce aux service workers qui permettent à l'application de fonctionner hors connexion ou en très bas débit.
- Sécurité garantie : l'utilisation des Service Workers est conditionné par le fait que le site est délivré en https. 
- Ré-engagement de l'utiliseeur grâce :
    - aux notifications push,
    - à la possibilité d'installer un bon vieux favori sur l'écran d'accueil de l'appareil (sur mobile, tablette...).

Le poids d'une app native est souvent minimum x10 par rapport à son équivalent web optimisé pour mobile.
Dans nos contrées où le haut-débit et la 4G sont des normes, il en n'est pas de même dans les pays en voie de développement.
De plus, nous ne profitons pas toujours d'une connectivité ou d'un débit constant.
Dans les transports souterrains, dans un lieu confiné ou dans de lointaines campagnes, il n'est pas rare d'être complètement "déconnecté".

Des retours sur inverstissement assez impressionnants :

- [AliExpress](https://developers.google.com/web/showcase/2016/aliexpress) : 104% de nouveaux utilisateurs quelque soit le navigateur utilisé ; 82% de hausse du taux de conversion des utilisateurs iOS,
- [eXtra Electronics](https://developers.google.com/web/showcase/2016/extra) : 100% d'augmentation des ventes avec les Web Push Notifications,
- [Jumia](https://developers.google.com/web/showcase/2016/jumia) : 9 fois plus de conversions de paniers abandonnés avec les Web Push Notifications,
- [5miles](https://developers.google.com/web/showcase/2016/5miles) : 30% de hausse de la conversion des utilisateurs qui passent par l'app placée en écran d'accueil.

## Mettez-vous au "Offline-first" !

Depuis plusieurs années, il existe une technologie planquée dans nos navigateurs permettant de gérer du cache et donc de faire du hors-ligne : [Application Cache](https://developer.mozilla.org/fr/docs/Web/HTML/Utiliser_Application_Cache)
mais celle-ci est dépréciée au profit des [Services Workers](https://developer.mozilla.org/fr/docs/Web/API/Service_Worker_API/Using_Service_Workers).

Stratégies pour la gestion du cache : Jake Archibald, un des ingénieurs de Google [The offline cookbook](https://jakearchibald.com/2014/offline-cookbook/)

## Ajout d'un site à l'écran d'accueil

Le Web App Manifest a pour but d'installer des applications Web sur l'écran d'accueil d'un appareil, notamment les smartphone,
offrant aux utilisateurs un accès plus rapide.
https://developer.mozilla.org/fr/docs/Web/Manifest
https://developers.google.com/web/fundamentals/engage-and-retain/web-app-manifest/

## Push Notifications

https://developers.google.com/web/fundamentals/getting-started/codelabs/push-notifications/
https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/

## C'est réservé aux apps mobile ?

Il est vrai que les problèmes de connectivité on l'a surtout en position de mobilité et grâce à la gestion du cache, une web app reste utilisable même en mode déconnecté.
Mais rien ne vous empêche d'utiliser les Services Workers pour booster vos applications web *desktop*.

## Outils

- [Service Worker Precache](https://github.com/GoogleChrome/sw-precache/) un module node pour faciliter la gestion de la mise en cache des ressouces statiques (HTML, JavaScript, CSS, images, etc.) via les Service Worker. Un [codelab](https://codelabs.developers.google.com/codelabs/sw-precache/index.html) est disponible.
- [Service Worker Toolbox](https://github.com/GoogleChrome/sw-toolbox) est un ensemble d'outils permettant notamment de gérer le *routing* vers du contenu caché ou du contenu en ligne.
- [Lighthouse](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk) est une extension Chrome permettant d'analyser une page et nous aider à implémenter les bonnes pratiques d'une Progressive Web App.

## Safari et iOS ?

Autant vous le dire tout de suite. Une Progressive Web App fonctionne sous iOS, mais vous ne profiterez ni des Services Workers, ni donc de la mise en cache et des notifications Push.
Inutile d'utiliser un navigateur Chrome sur votre iPhone ou votre iPad, iOS n'est pas encore prêt.
L'implémentation des Services Workers dans WebKit, le moteur de rendu de Safari, est "[under consideration](https://webkit.org/status/#specification-service-workers)".

Du côté de chez [Microsoft Edge](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/serviceworker/), les Services Workers sont en cours d'implémentation.

Pour suivre l'avancement de l'implémentation de Service Worker, un site : [Is Service Worker Ready?](https://jakearchibald.github.io/isserviceworkerready/)

## Démos

- [Pokedex.org](https://www.pokedex.org/) est une web app que vous pouvez consulter en mode déconnecté.
- [Wikipedia offline demo](https://wiki-offline.jakearchibald.com/) est une démo montrant les possibilités de concevoir les applications en "offline-first".

## Et après ?

Que peut-on ajouter à notre Progressive Web Apps pour encore améliorer l'expérience utilisateur ?

- [Credential Management API](https://developers.google.com/web/updates/2016/04/credential-management-api) pour faciliter l'authentification de l'utilisateur.
- [Payment Request API](https://developers.google.com/web/updates/2016/07/payment-request) pour faciliter les paiements sur Internet.
- [BackgroundSync](https://github.com/WICG/BackgroundSync/blob/master/explainer.md) pour permettre la synchronisation de données en tâche de fond dès lors que la connectivité est retrouvée.

Devinez-quoi ? Ces technologies ne sont disponibles que dans les dernières versions de Chrome.
Cependant c'est très prometteur. A suivre donc de près !


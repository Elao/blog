---
type:               "post"
title:              "Conception et développement d'API : l'interview croisée de l'équipe Élao"
date:               "2017-11-21"
publishdate:        "2017-11-21"
draft:              false
slug:               "api-design-elao-team-interview"
description:        "Interview croisée des développeurs d'Élao à propos de leurs diverses expériences en conception et développement d'API"
summary:            true

thumbnail:          "/images/posts/thumbnails/hexagons.jpg"
header_img:         "/images/posts/headers/hexagons.jpg"
tags:               ["API", "Conception", "REST", "API Design"]
categories:         ["Dev"]

author_username:    "elao"
---

Concevoir et développer une API n'est pas un exercice trivial. La littérature en la matière et les ressources sur Internet abondent, mais au moment d'implémenter une API, le développeur reste confronté à de nombreux choix.

Plutôt qu'énumérer une litanie de bonnes pratiques pontifiantes, nous donnons la parole à nos développeurs pour qu'ils partagent leurs expériences, vous livrent leurs points de vue ainsi que des conseils utiles sur les nombreux aspects techniques qui touchent aux API.

## Pouvez-vous résumer votre expérience des API en quelques mots ?

__Yves__ : Mon expérience concerne principalement des API privées, pour lesquelles les contraintes de versioning ou de documentation ne constituent donc pas des enjeux forts. Les API sur lesquelles j'ai travaillé étaient principalement basées sur les principes REST, conçues la plupart dans le contexte de micro-services ou de Backends applicatifs. J'ai eu l'occasion d'utiliser différents formats d'API : [Collection+JSON](http://amundsen.com/media-types/collection/format/), [HAL](http://stateless.co/hal_specification.html), [json:api](http://jsonapi.org/), etc.

## Y a-t-il un code HTTP peu connu que vous utilisez régulièrement ?

__Yves__ : J'utilise régulièrement le code 422 (extension du protocole HTTP [Webdav](https://fr.wikipedia.org/wiki/WebDAV)) pour remonter des erreurs de validation métiers, et les distinguer ainsi du code 400 que l'on réserve habituellement aux requêtes mal formées. Cette distinction conventionnelle offre une meilleure lisibilité des erreurs côté consommateur.

## Choisir entre les méthodes `POST`/`PATCH`/`PUT` : conseils, critères de choix ?

__Yves__ : J'utilise souvent la méthode `PUT` dans le cadre d'une relation 0:1 : si la ressource n'existe pas, elle est créée, dans le cas contraire, la totalité de la ressources est mise à jour. Cela permet d'implémenter pleinement l'idempotence de la méthode `PUT` (l'URI peut être appelée plusieurs fois, elle laissera toujours la ressource dans le même état). J'essaie dans la mesure du possible d'éviter l'utilisation de la méthode `PATCH`, car c'est un format d'opération somme toute assez complexe (cf. [RFC 6902](https://tools.ietf.org/html/rfc6902#section-4)). Quant à la méthode `POST`, je l'utilise pour la création de ressource, comme une méthode _factory_. Noter d'ailleurs que je m'autorise parfois quelques infractions aux principes REST, mais sans en abuser. Il m'arrive par exemple d'utiliser la méthode `POST` avec une URI qui comporte un verbe, même s'il ne s'agit pas à proprement parler d'une création de ressource. Exemple : `POST  /ma-resource/{id}/changeAddress`. Je m'autorise cette infraction lorsque j'estime qu'elle apporte une meilleure compréhension du métier, et également pour obtenir des logs plus parlants.

## Formats de sortie : privilégiez-vous le tout JSON ?

__Yves__ : J'ai effectivement pour habitude de privilégier ce format par défaut, mais les contraintes métiers vous obligent parfois à prévoir d'autres formats de sortie, comme le PDF par exemple. Lorsque je travaille sur des API assez complexes, j'ai tendance à favoriser le format json:api.

## Gestion des erreurs, erreurs de validation : formalisme, pratiques ?

__Yves__ : J'ai eu l'occasion de tester plusieurs formats de sortie, et au final, je me suis plié à l'usage courant en adoptant le format `problem+json` . Je m'appuie bien entendu sur les codes HTTP pour retourner des erreurs, mais je peux parfois les compléter par des codes métiers _custom_ transmis dans le corps de la réponse, lorsque j'estime que cela apporte quelque chose. J'essaie néanmoins de limiter cette pratique pour ne pas avoir à maintenir un référentiel des codes erreurs personnalisés.

## Le versioning d'API : quelle stratégie préconisez-vous ?

__Yves__ : J'ai eu l'occasion d'implémenter les deux stratégies (version dans l'URL ou dans un _header_) et au final, j'ai une nette préférence pour la version incluse dans l'URL, car cela facilite la tâche côté utilisateur ; de plus, cette stratégie a le mérite de la visibilité, en particulier dans les fichiers de log.

## Avez-vous des pratiques particulières concernant les URI ? Bannissez-vous sytématiquement les verbes ? Dans quels cas les utilisez-vous ?

__Yves__ : Concernant les verbes dans les URI, j'ai déjà eu l'occasion d'y répondre. Sauf cas particulier (exemple: une arborescence de fichiers), je m'efforce généralement de ne pas aller au-delà de deux niveaux de ressources dans mes URI. Exemple : `/users/{id}/friends`. J'utilise toujours le pluriel pour mes ressources et m'autorise des pluriels anglais peu académiques lorsque j'estime que cela améliore la lisibilité des ressources (exemple: `persons` au lieu de `people`). Pour les mots composés, je privilégie l'usage du tiret (plutôt que le _camelCase_) car je trouve ça plus lisible. Je n'hésite pas non plus à utiliser des noms de ressources verbeux et des termes orientés métiers. En d'autres termes, je n'hésite pas à privilégier la lisibilité et la verbosité au détriment de la concision.

## Un petit mot sur HATEOAS ?

__Yves__ : J'ai été un adepte de la première heure et j'ai été dès le début séduit par sa philosophie, en particulier le concept de découverte d'une API par l'usage. Il faut dire qu'à l'époque, les API exposaient facilement leurs opérations de lecture, mais il était moins aisé de découvrir les opérations d'écriture. Aujourd'hui, je suis moins sensible à HATEOAS, pour plusieurs raisons : la maintenance que cela implique, le peu d'intérêt que cela présente pour les développements Frontend et le nombre d'appels nécessaires pour trouver le _endpoint_ souhaité. En outre, le format json:api prévoit des fonctionnalités de navigation simplifiées qui suffisent amplement à mes besoins.

## Utilisez-vous une bibliothèque-cadre pour développer vos API ? Symfony REST edition ? API-platform ? Autre ?

__Yves__ : J'avais eu l'occasion de tester [api blueprint](https://apiblueprint.org/) et j'avais notamment apprécié ses générateurs (documentation, tests, code client) mais je me suis aussi heurté à certaines de ses limites (il fallait parfois que j'adapte ma conception à l'outil). Aujourd'hui, je n'utilise pas de librairie orientée API. Mes développements s'appuient essentiellement sur Symfony, et sur les écouteurs d'événements, pour traiter les erreurs (_Exception listener_) ou constuire mes ressources depuis la requête HTTP (_Request listeners_) ...

## Communication développeurs Backend/Frontend : des conseils ?

__Yves__ : J'ai plutôt tendance à privilégier la discussion orale plutôt qu'une documentation "anémique" à outrance. Mais je dois avouer que j'ai essentiellement travaillé dans des petites équipes où la communication n'était pas entravée.

## Et GraphQL dans tout ça ?

__Yves__ : C'est une philosophie différente de REST, qui mérite que l'on s'y intéresse. Mais j'attends également avec impatience les apports du protocole HTTP/2 et je souhaite notamment voir s'il permettra de limiter les appels HTTP, qui est une des problématiques qu'entend adresser GraphQL.

## Quel conseil donneriez-vous à un développeur qui débute dans les API ?

__Yves__ : Il ne faut pas hésiter à s'inspirer des API existantes développées par de grands acteurs du Web (Spotify, Github, etc.). Ils ont eu à se frotter aux principales problématiques qu'impliquent la conception et le développement d'une API et on aurait tort de se priver de leur expérience. Quoi qu'il en soit, je pense que quelles que soient les règles que vous vous fixez, le plus important (mais pas le plus simple!), c'est de conserver une cohérence globale.

## Une question que vous auriez aimé que l'on vous pose à propos des API ? Ou bien quelque chose à ajouter ?

__Yves__ : N'hésitez pas à consulter la liste des headers HTTP natifs. Nous connaissons tous les headers d'authentification, mais il en existe bien d'autres qui peuvent être tout-à-fait adaptés aux informations que l'on souhaite retourner. Exemples : les headers d'authentification, les headers de langue et d'internationalisation. Il faut également savoir qu'il existe des headers proposés par des extensions HTTP et il arrive parfois que ces headers entrent dans la spécification HTTP (comme par exemple le header `x-forwarded-by` objet de la RFC 7239). En revanche, avant d'adopter un header, qu'il soit standard ou extrait d'une extension, assurez-vous que vos proxies HTTP les supportent. On peut parfois être amené à enfreindre des standards lorsque l'outillage ou l'infrastructure nous y contraint. En résumé, il ne faut jamais perdre de vue l'infrastructure qui accueillera votre API au moment de la concevoir et c'est un piège que l'on a souvent tendance à négliger.


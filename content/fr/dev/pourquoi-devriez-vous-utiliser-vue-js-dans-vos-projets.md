---
type:               "post"
title:              "Pourquoi devriez-vous utiliser Vue.js dans vos projets ?"
date:               "2016-10-17"
publishdate:        "2016-10-17"
draft:              false
slug:               "pourquoi-devriez-vous-utiliser-vue-js-dans-vos-projets"
description:        "Retour d'expérience sur le framework frontend Vue.js et pourquoi l'utiliser"

language:           "fr"
thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Vue.js","Javascript","Front","Frontend","Framework"]
categories:         ["Dev", Vue.js", "Javascript"]

author_username:    "mcolin"
---

A l'heure de framework front, et à contrepier des désormais conventionnels Angular, Riot, Amber ou encore React, j'ai décidé de m'intéresser à [Vue.js](https://vuejs.org/). **Vue.js** est un framework javascript dévoloppé par Evan You qui se veut accessible, versatile et performant.

## Accessible

A comparaison de ce que j'ai pu tester avec d'autres framework front, j'ai effectivement trouvé que Vue.js est très simple à mettre en place. La création d'une application basique se fait en quelques lignes de code et les résultats sont rapidement là.

Voici à titre d'exemple une "[TODO List](https://jsfiddle.net/Lsgc2rhr/9/)" réalisé en quelques minutes avec seulement une vingtaine de lignes de Javascript.

<script async src="//jsfiddle.net/Lsgc2rhr/9/embed/js,html,result/"></script>

## Versatile

La versalité de **Vue.js** vient de la possibilité d'utiliser le framework de différente façon plus ou moins poussées. Vous pouvez l'utiliser pour créer un petit widget qui s'intégrera sur une page en quelques lignes à la manière d'un plugin jQuery, réaliser des Single Page Application, créer vos propres composants, ou même créer des applications complexes avec du routing et cablée sur une API. Coté rendu, vous pouvez utiliser des templates HTML directement de le DOM, déclarer des templates inline ou packager votre template avec son composant dans un fichier ```.vue```. Bref, **Vue.js** s'adapte à vos besoins.

## Performant

Que celà soit en soit sur pour un petit widget ou pour une application multi-page, je n'ai pas trouvé de problème de performance. Tout est fluide, le rendu est rapide et la synchronisation des données efficace. Je n'ai pas fait de benchmark parce qu'on en trouve déjà plein le web, le site de Vue.js fait lui même une comparaison avec différents frameworks.

* [JS web frameworks benchmark – Round 1](http://www.stefankrause.net/wp/?p=191)
* [JS web frameworks benchmark – Round 2](http://www.stefankrause.net/wp/?p=283)
* [Comparison with Other Frameworks](https://vuejs.org/guide/comparison.html)
* [Vue.js lead: Our JavaScript framework is faster than React](http://www.infoworld.com/article/3063615/javascript/vuejs-lead-our-javascript-framework-is-faster-than-react.html)
* [Consider VueJS for Your Next Web Project](https://blog.codeship.com/consider-vuejs-next-web-project/)

Ils s'accordent tous pour dire que le framework est vraiment perfomant et compétitif par rapport aux autres solutions. Certains vont même plus loin en affirmant qu'il est plus rapide que des gros framework comme React.

## Fonctionnalités

Le coeur de **Vue.js** ce concentre sur la couche de présentation (vue). Il dispose pour celà de fonctionalités de templating avancé basé sur des directives préfixées d'un ```v-``` à la manière d'Angular et de ses propriété ```ng:```. La création des templates est ainsi simple et rapide, autant pour un développeur que pour un intégrateur.

Il offre la possibilité de créer ses propre directives, de créer des composants et des mixins (un peu comme les traits de PHP).

Les composants peuvent être déclarer simplement dans un fichier Javascript et attache à un templates dans votre HTML ou vous pouvez créer des Single File Components sous la forme de fichiers ```.vue``` rassemblant le template, le javascript et le CSS de votre composant.

Un systeme d'événement est disponible pour faire communiquer les composants ensemble.

### Plugins

**Vue.js** dispose de plugins afin d'ammener d'autres fonctionnalités au framework :

* **vue-resources** permet de réaliser des requêtes AJAX sur une API.
* **vue-router** permet de gérer le routing de votre application
* **vue-validator** permet de valider vos formulaires
* **vuex** est un state manager pour Vue.js (équivalent de Flux/Redux)
* [et bien d'autres](https://github.com/vuejs/awesome-vue#libraries--plugins)

### Environnement de développement

**Vue.js** est compatible avec [WebPack](https://webpack.github.io/docs/) et [Browserify](http://browserify.org/). [Vue CLI](https://github.com/vuejs/vue-cli), un outils en ligne de command, propose un environnement de développement complet et moderne avec de la génération de boilerplate, de la compilation, du watching, du live reload, ...


## Intégration avec Symfony

Développant mojoritairement avec Symfony, un gros plus que j'ai trouvé au framework est qu'il s'intègre très simplement à Symfony. Il est en effet possible de mélanger vos templates **Vue.js** et vos templates **Twig** et il est très simple d'y intégrer des composants voir de cabler une application **Vue.js** sur une template ou un formulaire Symfony.

## Conclusion

En conclusion, pour moi sa **versabilité** et sa **flexibilité** sont les plus gros avantages de **Vue.js**. Bien qu'il dispose de tout ce qu'il faut pour développer une SPA ou une application frontend complexe, il est également très simple de réaliser un petit composant. C'est pourquoi je le recommande pour intégrer un peu de dynamisme à une application backend mais également pour développer une application frontend. Ces avantages permettent également une courbe d'aprentisage plus douce qu'avec un framework plus complexe.
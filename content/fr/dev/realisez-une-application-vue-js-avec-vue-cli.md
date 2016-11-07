---
type:               "post"
title:              "Réalisez une application Vue.js avec vue-cli"
date:               "2016-11-04"
publishdate:        "2016-11-04"
draft:              false
slug:               "realisez-une-application-vue-js-avec-vue-cli"
description:        "Introduction à la réalisation d'applications frontend avec Vue.js et vue-cli."

language:           "fr"
thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Vue.js","Javascript","Front","Frontend","Framework"]
categories:         ["Dev", "Vue.js", "Javascript", "Symfony"]

author_username:    "mcolin"
---

Dans mes précédents articles je vous présentais [pourquoi utiliser Vue.js dans vos projets](/fr/dev/pourquoi-devriez-vous-utiliser-vue-js-dans-vos-projets/) et [comment intégrer Vue.js à une application Symfony](/fr/dev/comment-integrer-vue-js-application-symfony/). Je vais maintenant vous présenter une autre facette du framework d'Evan You, la création d'application frontend grâce à l'outils [vue-cli](https://github.com/vuejs/vue-cli).

## vue-cli

Comme je l'avais annoncer, le framework est très **polyvalent**. Facile à utiliser et à intégrer à une technologie backend, il permet également de réaliser des applications frontend. Et pour nous faciliter la chose, le framework met à notre disposition ```vue-cli```, un outils en ligne de commande qui encapsule et automatise tout ce dont vous aurez besoin pour créer votre application **Vue.js**.

L'installation se fait simplement grâce à ```npm``` :

```
$ npm install -g vue-cli
```

L'outils permet en premier lieu d'initier votre projet, grâce à la commande suivante : 

```
$ vue init <template-name> <project-name>
```

Plusieurs template sont disponibles, proposant différentes fonctionnalités et bundler (webpack ou browserify). J'ai testé le template ```webpack``` qui propose la compilation avec **Webpack**, **Babel**, le **hot reload**, le **code linting**, les **tests unitaires** et les **tests fonctionnels**. Vous pouvez utiliser les templates fournis ou un template externe.

La commande vous invitera ensuite à rentrer les informations nécessaires à la configuration de votre projet puis généra une arborescence avec une base de projet type "Hello world".

<img src="/fr/images/posts/2016/vuecli-console.jpg" alt="Console" />

Vous exécutez ensuite les commandes ```npm install``` et ```npm run dev```, votre application sera accessible sur l'url ```http://localhost:8080/```

<img src="/fr/images/posts/2016/vuecli-app.jpg" alt="Application" />

## Architecture

<img src="/fr/images/posts/2016/vuecli-tree.jpg" alt="Tree" style="float:right;max-width:30%;margin-left: 20px;margin-bottom: 20px;" />

L'application est composé d'un fichier ```main.js``` servant de point d'entrée, d'un fichier ```index.html``` affichant votre application et de composants sous la forme de fichiers ```.vue```. De base vous aurez 2 composants, ```App.vue``` qui sera votre *root componant* et ```Hello.vue``` qui est votre *Hello world*.

Vous avez un répertoire ```components``` pour vos composants et un répertoire ```assets``` pour vos images, css, etc.

Les fichiers ```.vue``` permettent de définir des [Single File Components](https://vuejs.org/guide/single-file-components.html) réutilisables et de bien découper votre application. Ces fichiers encapsulent le code Javascript, le template et le CSS de leur composant respectivement dans des balise ```<script>```, ```<template>``` et ```<style>```. Par defaut les composants sont développés en **ES6** qui sera transpilé grâce **Babel**.

Un attribut ```scoped``` sur la balise de style vous permettra de limiter le CSS à son composant uniquement. Vous pouvez néanmoins tout à fait gérer votre style globalement dans des fichiers CSS inclu depuis le fichier ```index.html``` ou compiler du **SASS** ou du **LESS** en configurant **Webpack** dans le répertoire *build*.

Grâce au **hot reload**, la moindre modification de code rechargera automatiquement votre navigateur.

<div style="clear:both;"></div>

<figure>
{{<highlight html>}}
<template>
    <div class="hello">
        <h1>{{ msg }}</h1>
    </div>
</template>

<script>
export default {
    name: 'hello',
    data () {
        return {
            msg: 'Welcome to Your Vue.js App'
        }
    }
}
</script>

<style scoped>
h1 {
    font-weight: normal;
}
</style>
{{</highlight>}}
	<figcaption style="text-align: center;font-style: italic;">Contenu d'un fichier .vue</figcaption>
</figure>

## Template

J'ai trouvé les templates par defaut assez complet, néanmoins si vous avez besoin de développer courament des applications avec une architecture ou des dépendances particulières, **vue-cli** vous permet de créer [vos propres templates](https://github.com/vuejs/vue-cli#custom-templates) afin de *scaffolder* vos applications rapidement. 

Un template peu être chargé depuis un repo git ou depuis un chemin local. Vous pouvez fork un template existant ou en créer un de zéro.

## Centralized State Management

Si vous développez une application relativement complexe et que vous partager des données entres plusieurs composants, vous aurez certainement besoin d'un gestionnaire d'état. Si pour une application simple un [bus d'événement global](https://vuejs.org/v2/guide/components.html#Non-Parent-Child-Communication) peut suffir pour faire communiquer vos composants ensemble, pour une application plus complexe je vous conseil d'utiliser [VUEX](https://github.com/vuejs/vuex). **VUEX** est une bibliothèque de gestion d'états centralisé pour **Vue.js** vous permettant de créer des repository de données accéssible depuis tout vos composants.

## Exemple

L'équipe de **Vue.js** a récemment partagé les sources d'un [clone d'Hackernews](https://github.com/vuejs/vue-hackernews) realisé entièrement en Vue.js. Les sources sont largement commenté afin de vous permettre de comprendre le fonctionnement de Vue.js et de vous en inspirer pour développer vos applications.

## Dev tool

J'en avais pas encore parler mais Vue.js propose un [dev tool](https://github.com/vuejs/vue-devtools) très pratique sous la forme d'une extension chrome. Cette extension se place dans un onglet du **dev tool** de Chrome et vous permet d'accéder à l'état de tous vos composants et de facilement débuger votre application.

<figure>
	<img src="/fr/images/posts/2016/vuecli-devtool.png" alt="Application" />
	<figcaption style="text-align: center;font-style: italic;">Devtools Vue.js</figcaption>
</figure>

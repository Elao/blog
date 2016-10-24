---
type:               "post"
title:              "Comment intégrer Vue.js dans une application Symfony"
date:               "2016-10-21"
publishdate:        "2016-10-21"
draft:              false
slug:               "comment-integrer-vue-js-application-symfony"
description:        "Guide d'intrégration de Vue.js dans une application Symfony"

language:           "fr"
thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Vue.js","Javascript","Front","Frontend","Framework","Symfony"]
categories:         ["Dev", "Vue.js", "Javascript", "Symfony"]

author_username:    "mcolin"
---

Dans mon [précédent article](/fr/dev/pourquoi-devriez-vous-utiliser-vue-js-dans-vos-projets/) je vous parlais des avantages de Vue.js et de pourquoi vous dévriez l'utiliser dans vos projets. Je disais que Vue.js était parfait pour ajouter des fonctionnalités frontend à **Symfony**, je vais vous détailler dans cet article comment intégrer **Vue.js** au framework de **Sensio**.

## {{ delimiters }}

La principale difficulté à l'intégration d'un framework frontend comme **Vue.js** dans une application **Symfony** vient du templating. Et pour cause, les moteurs de templating des deux frameworks utilisent les délimiteurs ```{{``` et ```}}``` pour afficher des variables.

Fort heureusement, il est possible de changer les délimiteurs dans les deux moteur de templating. Pour Twig, [ça se passe là](http://twig.sensiolabs.org/doc/recipes.html#customizing-the-syntax), mais nous allons plutôt nous attarder sur **Vue.js** puisque c'est lui que nous intégrons dans **Symfony**.

Vous pouvez changer les délimiteur sur une instance de Vue :

```
new Vue({
  delimiters: ['${', '}']
})
```

ou globalement pour toutes les instances de Vue :

```
Vue.config.delimiters = ['${', '}'];
```

Vous pourrez ainsi mélanger les deux moteurs de templates :

```
<h1>{{ variable_twig }}</h1>
<p>${ variable_vue }<p>
```

Si vous decidez de ne pas changer les délimiteurs, vous pouvez utilise le tag ```{% verbatim %}``` afin d'indiquer à Twig de ne pas interpréter votre template vue :

```
<h1>{{ variable_twig }}</h1>
{% verbatim %}
    <p>{{ variable_vue }}<p>
{% endverbatim %}
```

Une troisième solution serait de contenir le template **Vue.js** dans une chaine de caractère Twig. Personnellement j'essaie d'éviter cette solution, mais elle peut dépanner très occasionnellement.

```
<h1>{{ variable_twig }}</h1>
<p>{{ '{{ variable_vue }}' }}<p>
```

## Template

Il y a plusieurs façon de déclarer les templates dans **Vue.js**. Concernant le template principale, il se placera systématiquement sous l'élément sur lequel vous montez votre application.

Par exemple si j'ai l'application suivante :

```
new Vue({
    el: '#app',
    data: {
        greating: "Hello world"
    }
});
```

Dans mon templates Twig j'aurais :

```
{% extends '::base.html.twig' %}

{% block content %}
    <h1>Homepage</h1>
    <div id="app">
        <h2>${ greating }</h2>
    </div>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
{% endblock %} 
```

Dans le cas d'un composant, vous avez le choix de déclarer votre template dans un fichier ```.vue``` (Single File Component), dans une balise ```<script><script>``` ou inline.

### Single File Component

Si vous créez un Single File Component, votre composant et son template seront completement décorélé de Symfony et Twig. Vous serez en outre obligé d'utilise un plugin pour importer les fichiers avec **Browserify** ou **Webpack**.

```
<template>
    <h2>${ greating }</h2>
</template>

<script>
    module.exports = {
        data: function () {
            return {
                greating: "Hello world"
            };
        }
    };
</script>
```

Néanmoins vous aurez l'avantage d'avoir un composant complètement autonome et réutilisable facilement.

### Script X Template

La solution que j'utilise le plus souvent consiste à placer le template dans une balise script qui sera référencé dans le composant via son id.

```
<script id="my-component" type="text/x-template">
    <div>
        <h1>${ greating }</h1>
    </div>
</script>
```

```
Vue.component('my-component', {
    template: '#my-component',
    data: function () {
        return {
            greating: 'Hello'
        };
    }
});
```

Cette solution peut permettre de placer votre template de composant dans un fichier Twig que vous incluerez sur toutes les pages qui utilisent ce composant et permet d'alléger votre template principal.

### Template inline

Cette solution consiste à déclarer le template au moment où vous utilisez le composant. Vous pourez ainsi écrire tout le code côté HTML d'un coup et profiter du découpage en composants côté Javascript. Cet option peut être utile pour utiliser un template différent pour plusieurs utilisations d'un même composant. En contre partie le composant perd en réutilisabilité.

```
<div id="app">
    <my-component inline-template>
        <h1>${ greating }</h1>
    </my-component>
</script>
```

### Template interne

La dernière possiblité permet de déclarer le template directement dans le code Javascript du composant. Cette solution est la moins flexible et n'a à mon sens d'intéret que pour un composant très simple.

```
Vue.component('my-component', {
    template: '<h1>${ greating }</h1>',
    data: function () {
        return {
            greating: 'Hello'
        };
    }
});
```

## Les props

Les **props** sont des propriétés qui peuvent être données en entrée du composant. Elles servent à passer des données d'un composant parent à un composant enfant. Vous pouvez néanmoins y passer des données brut et donc les utilisers pour passer des données de **Symfony** à **Vue.js**. Attention ces données sont accessibles en lecture seulement.

Imaginons par exemple un composant qui liste des éléments qu'il récupère à partir de l'API de votre application. Vous pouvez utilise les **props** pour passer la configuration depuis **Symfony**.

```
Vue.component('foobar-list', {
    props: {
        apiUrl: String,
        itemPerPage: Number
    }
});
```

```
{% set itemPerPage = 5 %}
<foobar-list 
    v-bind:apiUrl="'{{ path('api_foobar_list') }}'" 
    v-bind:itemPerPage="{{ itemPerPage }}"></foobar-list>
```

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention, les <strong>props</strong> doivent être des valeurs intépretables par <strong>Javascript</strong> et compatibles avec les types renseignés au niveau du composant (ici <code>String</code> et <code>Number</code>), c'est pourquoi j'ai mit des guillements autour de mon url dans <code>v-bind:apiUrl</code>.
</div>

## Formulaire

### Two-way binding

Grace à la propiété ```v-model``` vous pouvez très facilement lié les ```data``` d'un composant **Vue.js** avec un champ de formulaire. Cette liaison est bi-directionnelle (two-way binding), c'est à dire que les modifications des données dans le composant se repercutennt sur le formulaire et que les modifications des valeurs du formulaires se répercutent sur les données du composant.

<script async src="//jsfiddle.net/hw4z8t91/1/embed/js,html,result/"></script>

Vous pouvez donc simplement ajouter cet attribut sur vos champs pour lié votre formulaire **Symfony** à votre application **Vue.js**. Vous profiter ainsi de la puissance du composant Form de Symfony (génération, validation, theming, ...) et des fonctionnalités de **Vue.js**

```
new Vue({
    el: '#app',
    data: {
        search: null
    }
});
```

```
<div id="app">
    {{ form_start(form) }}
        {{ form_widget(form.search, { 'attr': { 'v-model': 'search' } }) }}
    {{ form_end(form) }}
</div>
```

### Evénements

**Vue.js** propose également plusieurs directives ```v-on:*``` permettant d'écouter les événements Javascript (```click```, ```submit```, ```change```, ...). Ces directives peuvent être suivie d'un ou plusieurs ***modifier*** permettant par exemple de stopper la propagation de l'événement (```.stop```) ou d'annuler de comportement par defaut de l'événement (```.prevent```).

Par exemple, si je souhaitais blocker le submit d'un formulaire et appeler une function de callback à la place, j'utiliserais la directive ```v-on:submit.prevent``` :

```
new Vue({
    el: '#app',
    data: {
        search: null
    },
    methods: {
        performSearch: function () { // Recherche en ajax par exemple }
    }
});
```

```
<div id="app">
    {{ form_start(form, { 'attr': 'v-on:submit.prevent': 'performSearch' }) }}
        {{ form_widget(form.search, { 'attr': { 'v-model': 'search' } }) }}
    {{ form_end(form) }}
</div>
```

### Watch

Une autre fonctionnalité très pratique pour les formulaires est le [watch](http://vuejs.org/api/#watch) qui permet de surveiller une données **Vue.js** et d'appeler un callback à chaque modification. Si je preprend l'exemple si dessus, cela permettrait d'effectuer la recherche à chaque changement de valeur.


```
new Vue({
    el: '#app',
    data: {
        search: null
    },
    methods: {
        performSearch: function () { // Recherche en ajax par exemple }
    },
    watch: {
        search: function (newValue, oldValue) {
            this.performSearch();
        }
    }
});
```

Notez que dans les callbacks de watch, vous avez accès à la nouvelle et l'ancienne valeur.

<div style="border-left: 5px solid #1b809e;padding: 20px;margin: 20px 0;">
    Si vous avez bien suivie le chapitre sur les événements, vous vous demandez surement pourquoi utiliser le <code>watch</code> plutôt que de mettre un <code>v-on:change</code> sur le champ. La différence est que le <code>v-on:change</code> écoutera les modifications de l'élement DOM alors que le <code>watch</code> écoutera les modifications sur le modèle.
</div>


## API

Pour aller encore plus loin dans l'intégrations de **Vue.js** à votre application **Symfony**, vous aurez certainement besoin d'une API. Le plugin [vue-resource](https://github.com/vuejs/vue-resource) vous permettra facilement de faire vos requêtes AJAX. 


```
new Vue({
    methods: {
        fetch: function () {
            this.$http.get('/someUrl').then((response) => {
                // success callback
            }, (response) => {
                // error callback
            });
        }
    }
})

```

Le plugin offre toutes les fonctionnalités nécessaire à l'interogation d'une API. Il supporte les promesses, les templates d'url, XMLHttpRequest et JSONP.

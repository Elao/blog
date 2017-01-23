---
type:               "post"
title:              "Comment intégrer Vue.js dans une application Symfony"
date:               "2016-10-21"
publishdate:        "2016-10-21"
draft:              false
slug:               "comment-integrer-vue-js-application-symfony"
description:        "Guide d'intrégration de Vue.js dans une application Symfony"

thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Vue.js","Javascript","Front","Frontend","Framework","Symfony"]
categories:         ["Dev", "Vue.js", "Javascript", "Symfony"]

author_username:    "mcolin"
---

Dans mon [précédent article](/fr/dev/pourquoi-devriez-vous-utiliser-vue-js-dans-vos-projets/) je vous parlais des avantages de Vue.js et vous expliquais pourquoi vous devriez l'utiliser dans vos projets. Je disais que Vue.js était parfait pour ajouter des fonctionnalités frontend à **Symfony**, je vais vous détailler dans cet article comment intégrer **Vue.js** au framework de **Sensio**.

## {{ delimiters }}

La principale difficulté à l'intégration d'un framework frontend comme **Vue.js** dans une application **Symfony** vient du templating. Et pour cause, les moteurs de templating des deux frameworks utilisent les délimiteurs ```{{``` et ```}}``` pour afficher des variables.

Fort heureusement, il est possible de changer les délimiteurs dans les deux moteurs de templating. Pour Twig, [ça se passe là](http://twig.sensiolabs.org/doc/recipes.html#customizing-the-syntax), mais nous allons plutôt nous attarder sur **Vue.js** puisque c'est lui que nous intégrons dans **Symfony**.

Vous pouvez changer les délimiteurs sur une instance de Vue :

```
new Vue({
  delimiters: ['${', '}']
})
```

ou globalement pour toutes les instances de Vue :

```
Vue.config.delimiters = ['${', '}'];
```

Vous pourrez ainsi utiliser conjointement les deux moteurs de templates :

```
<h1>{{ variable_twig }}</h1>
<p>${ variable_vue }<p>
```

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention néanmoins, le changement de délimiteurs de façon globale peut vous couper des composants tiers que vous pourriez installer et qui embarqueraient leur template avec les anciens délimiteurs.
</div>

Si vous decidez de ne pas changer les délimiteurs, vous pouvez utiliser le tag ```{% verbatim %}``` afin d'indiquer à Twig de ne pas interpréter votre template vue :

```
<h1>{{ variable_twig }}</h1>
{% verbatim %}
    <p>{{ variable_vue }}<p>
{% endverbatim %}
```

Une troisième solution est de contenir le template **Vue.js** dans une chaine de caractère Twig. Personnellement j'essaie d'éviter cette solution, mais elle peut dépanner très occasionnellement.

```
<h1>{{ variable_twig }}</h1>
<p>{{ '{{ variable_vue }}' }}<p>
```

## Template

Il y a plusieurs façons de déclarer les templates dans **Vue.js**. Concernant le template principal, il se placera systématiquement sous l'élément sur lequel vous montez votre application.

Par exemple si j'ai l'application suivante :

```
new Vue({
    el: '#app',
    data: {
        greeting: "Hello world"
    }
});
```

Dans mon templates Twig j'aurais :

```
{% extends '::base.html.twig' %}

{% block content %}
    <h1>Homepage</h1>
    <div id="app">
        <h2>${ greeting }</h2>
    </div>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
{% endblock %}
```

Dans le cas d'un composant, vous avez le choix de déclarer votre template dans un fichier ```.vue``` (Single File Component), dans une balise ```<script><script>``` ou inline.

### Single File Component

Si vous créez un Single File Component, votre composant et son template seront completement décorrélés de Symfony et Twig. Vous serez en outre obligé d'utiliser un plugin pour importer les fichiers avec **Browserify** ou **Webpack**.

```
<template>
    <h2>${ greeting }</h2>
</template>

<script>
    module.exports = {
        data: function () {
            return {
                greeting: "Hello world"
            };
        }
    };
</script>
```

Néanmoins vous aurez l'avantage d'avoir un composant complètement autonome et réutilisable facilement.

### Script X Template

La solution que j'utilise le plus souvent consiste à placer le template dans une balise script qui sera référencée dans le composant via son id.

```
<script id="my-component" type="x-template">
    <div>
        <h1>${ greeting }</h1>
    </div>
</script>
```

```
Vue.component('my-component', {
    template: '#my-component',
    data: function () {
        return {
            greeting: 'Hello'
        };
    }
});
```

Cette solution peut permettre de placer votre template de composant dans un fichier Twig que vous incluerez sur toutes les pages qui l'utilisent et permet d'alléger votre template principal.

### Template inline

Cette solution consiste à déclarer le template au moment où vous utilisez le composant. Vous pourrez ainsi écrire tout le code côté HTML d'un coup et profiter du découpage en composants côté Javascript. Cet option peut être utile pour utiliser un template différent pour plusieurs utilisations d'un même composant. En contre partie le composant perd en réutilisabilité.

```
<div id="app">
    <my-component inline-template>
        <h1>${ greeting }</h1>
    </my-component>
</div>
```

### Template interne

La dernière possibilité permet de déclarer le template directement dans le code Javascript du composant. Cette solution est la moins flexible et n'a à mon sens d'intéret que pour un composant très simple.

```
Vue.component('my-component', {
    template: '<h1>${ greeting }</h1>',
    data: function () {
        return {
            greeting: 'Hello'
        };
    }
});
```

## Les props

Les **props** sont des propriétés qui peuvent être données en entrée du composant. Elles servent à passer des données d'un composant parent à un composant enfant. Vous pouvez néanmoins y passer des données brutes et donc les utiliser pour passer des données de **Symfony** à **Vue.js**.

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention les <code>props</code> sont en <em>one-way-down</em>. Si vous modifiez un <code>data</code> d'un composant parent passé en <code>props</code> d'un composant enfant, la modification se répercutera sur le composant enfant. Mais modifier une <code>props</code> depuis son composant n'impactera pas le composant parent et vous obtiendrez un <code style="color: #ffa600">warning</code> de la part de Vue.

    Néanmoins, si vous passez un objet en <code>props</code>, les modifications des propriétés de l'objet seront répercutées sur le parent, car c'est la référence de l'objet passé en <code>props</code> qui est immutable.
</div>

Imaginons par exemple un composant qui liste des éléments qu'il récupère à partir de l'API de votre application. Vous pouvez utiliser les **props** pour passer la configuration depuis **Symfony**.

```
Vue.component('foobar-list', {
    props: {
        apiUrl: String,
        itemsPerPage: Number
    }
});
```

```
{% set itemsPerPage = 5 %}
<foobar-list
    v-bind:apiUrl="'{{ path('api_foobar_list') }}'"
    v-bind:itemsPerPage="{{ itemsPerPage }}"></foobar-list>
```

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention, les <strong>props</strong> doivent être des valeurs interprétables par <strong>Javascript</strong> et compatibles avec les types renseignés au niveau du composant (ici <code>String</code> et <code>Number</code>), c'est pourquoi j'ai mis des guillements autour de mon url dans <code>v-bind:apiUrl</code>.
</div>

## Formulaires

### Two-way binding

Grâce à la propiété ```v-model``` vous pouvez très facilement lier les ```data``` d'une application **Vue.js** avec un champ de formulaire. Cette liaison est bi-directionnelle (two-way binding), c'est à dire que les modifications des données dans Vue se repercutent sur le formulaire et que les modifications des valeurs du formulaires se répercutent sur les données de l'application Vue.

<script async src="//jsfiddle.net/hw4z8t91/1/embed/js,html,result/"></script>

Vous pouvez donc simplement ajouter cet attribut sur vos champs pour lier votre formulaire **Symfony** à votre application **Vue.js**. Vous profitez ainsi de la puissance du composant Form de Symfony (génération, validation, theming, ...) et des fonctionnalités de **Vue.js**

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

**Vue.js** propose également plusieurs directives ```v-on:*``` permettant d'écouter les événements Javascript (```click```, ```submit```, ```change```, ...). Ces directives peuvent être suivies d'un ou plusieurs ***modifier*** permettant par exemple de stopper la propagation de l'événement (```.stop```) ou d'annuler de comportement par defaut de l'événement (```.prevent```).

Par exemple, si je souhaitais bloquer le ```submit``` d'un formulaire et appeler une function de callback à la place, j'utiliserais la directive ```v-on:submit.prevent``` :

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

Une autre fonctionnalité très pratique pour les formulaires est le [watch](http://vuejs.org/api/#watch) qui permet de surveiller une donnée **Vue.js** et d'appeler un callback à chaque modification. Si je reprends l'exemple si dessus, cela permettrait d'effectuer la recherche à chaque changement de valeur.


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
    Si vous avez bien suivi le chapitre sur les événements, vous vous demandez surement pourquoi utiliser le <code>watch</code> plutôt que de mettre un <code>v-on:change</code> sur le champ. La différence est que le <code>v-on:change</code> écoutera les modifications de l'élément DOM alors que le <code>watch</code> écoutera les modifications sur le modèle.
</div>


## API

Pour aller encore plus loin dans l'intégration de **Vue.js** à votre application **Symfony**, vous aurez certainement besoin d'une API. Le plugin [vue-resource](https://github.com/vuejs/vue-resource) vous permettra facilement de faire vos requêtes AJAX.


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

Le plugin offre toutes les fonctionnalités nécessaires à l'interrogation d'une API. Il supporte les promesses, les templates d'url, XMLHttpRequest et JSONP.

#### MàJ du 4 novembre 2016

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention, Evan You, le créateur de Vue.js, vient d'annoncer que <a href="https://medium.com/the-vue-point/retiring-vue-resource-871a82880af4">vue-resource ne serait plus maintenu et recommandé par Vue.js</a>. Ce choix a été fait notamment car <code>vue-resource</code> fait doublon avec d'autres bibliothèques tierces. L'équipe préfère donc concentrer ses efforts sur les fonctionnalités propres à <strong>Vue.js</strong>. Vous pourrez toujours utiliser <code>vue-resource</code> dont le dépot sera transféré à <a href="https://github.com/pagekit">l'équipe de PageKit</a>, ses mainteneurs originaux.

    Si vous le souhaitez vous pouvez également migrer vers une autre bibliothèque comme <a href="https://github.com/mzabriskie/axios">axios</a> qui supporte les promesses et l'isomorphisme. Il est même possible de conserver l'accès <code>this.$http</code> ainsi :

    <pre>Vue.prototype.$http = axios</pre>
</div>

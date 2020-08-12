---
type:               "post"
title:              "Vue.js : Appeler une methode sur un composant enfant"
date:               "2020-08-12"
publishdate:        "2020-08-12"
draft:              false
slug:               "vuejs-appeler-une-methode-sur-un-composant-enfant"
description:        "Comment appleler une methode d'un composant enfant depuis son parent en Vue.js"

thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Vuejs","Javascript"]
categories:         ["Dev", "Javascript"]

author_username:    "mcolin"
---

L'approche composant de [Vue.js](https://fr.vuejs.org/index.html) permet de diviser votre interface en petits composants simples et réutilisables. Si cela permet effectivement de simplifier votre code, cela peut néanmoins compliquer la communication entre les différentes parties de votre interface. Nous allons voir dans cet article **comment un composant parent peut piloter un composant enfant en appelant ses méthodes**.

<!--more-->

Vous êtes sûrement déjà habitué à utiliser les canaux de communication classiques de Vue.js pour faire communiquer vos composants entre eux, à savoir [les props](https://fr.vuejs.org/v2/guide/components-props.html) pour les données descendantes (parent vers enfant) et [les événements](https://fr.vuejs.org/v2/guide/components.html#Envoyer-des-messages-aux-parents-avec-les-evenements) pour les données montantes (enfant vers parent).

Si les événements sont très pratiques pour appeler une méthode d'un composant en réagissant à un événement lancé par un composant enfant, il n'est pas toujours adéquat d'utiliser les props pour piloter un composant enfant.

Il est cependant possible **d'appeler une méthode d'un composant enfant directement depuis son parent**.

{{< highlight html >}}
<script>
// ComposantEnfant.vue
export default {
  methods: {
    doSomething() {
      // do something
    },
  },
}
</script>
{{< /highlight >}}

Pour cela, il faut que votre composant enfant dispose de l'attribut `ref` avec une valeur unique dans le composant parent.

{{< highlight html >}}
<script>
// ComposantParent.vue
export default {
  components: {
    ComposantEnfant,
  },
}
</script>

<template>
  <div>
    <ComposantEnfant ref="foobar"></ComposantEnfant>
  </div>
</template>
{{< /highlight >}}

Vous pouvez ensuite accéder à votre composant enfant via `$refs.foobar` et appeler directement ses méthodes.

Soit dans le code du composant :

{{< highlight html >}}
<script>
// ComposantParent.vue
export default {
  components: {
    ComposantEnfant,
  },
  methods: {
    foobar() {
      this.$refs.foobar.doSomething()
    },
  },
}
</script>

<template>
  <div>
    <ComposantEnfant ref="foobar"></ComposantEnfant>
  </div>
</template>
{{< /highlight >}}

Soit directement dans le template :

{{< highlight html >}}
<script>
// ComposantParent.vue
export default {
  components: {
    ComposantEnfant,
  },
}
</script>

<template>
  <div>
    <button v-on:click="$refs.foobar.doSomething()"></button>
    <ComposantEnfant ref="foobar"></ComposantEnfant>
  </div>
</template>
{{< /highlight >}}

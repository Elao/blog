---
type:               "post"
title:              "Two Way-Binding avec Vue et Vuex"
date:               "2018-08-12"
publishdate:        "2018-08-12"
draft:              false
slug:               "two-ways-binding-avec-vue-et-vuex"
description:        "Mise en place d'un Two-Way Binding avec Vue et Vuex."

thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Vuejs","Javascript","Front","Frontend","Framework"]
categories:         ["Dev", "Vuejs", "Javascript", "Symfony"]

author_username:    "mcolin"
---

Vue permet déjà de faire du Two-Way Binding grâce à la directive `v-model`. C'est à dire mettre à jour votre UI lorsque votre model change et vise-versa.

```
<script>
export default {
  data() {
    return {
      foobar: 'Lorem ipsum'
    }
  }
}
</script>

<template>
  <form>
    <input type="text" v-model="foobar" />
  </form>
</template>
```

Dans ce composant par exemple, lorsque la variable `foobar` est modifié, le contenu du champ est mis à jour et lorsque le contenu du champ est modifié, la variable `foobar` sera mise à jour.

Si nous introduisons Vuex (ou un autre state manager), les variables du store n'étant pas modifiable pas les composant, nous ne pouvons faire que du One-Way Binding (lorsque le model change, l'UI est mis à jour, l'inverse n'est pas possible).

```
<template>
  <form>
    <input type="text" v-model="$store.state.foobar" />
  </form>
</template>
```

Un composant comme celui-ci par exemple violerait le principe selon lequel les variables du store ne peuvent être modifié que par une mutation et jamais directement. Vous obtiendrez d'ailleurs un message d'erreur de la part de Vue.

La solution pour faire du Two-Way Binding est donc d'utiliser un computed avec un getter et un setter. Le getter renvoie la valeur stockée dans le store et le setter met à jour le store grâce à une mutation.

```
<script>
export default {
  computed: {
    foobar: {
      get() { return this.$store.state.foobar },
      set(value) { this.$store.commit('UPDATE_FOOBAR', value) }
    }
  }
}
</script>

<template>
  <form>
    <input type="text" v-model="foobar" />
  </form>
</template>
```

On retrouve alors un Two-Way Binding tout en respectant le principe de non modification directe du state.

L'ennuie avec cette méthode est qu'elle nécessite autant de getter/setter que de champs, ce qui peut vite vous amenez a écrire beaucoup de code lorsque vous avez de gros formulaire. On va donc voir une astuce pour simplifier tout ça.

On va s'inspirer des helpers `mapState`, `mapGetters` et `mapActions` de Vuex.

Par exemple :

```
<script>
export default {
  computed: {
    ...mapState(['foobar', 'barfoo'])
  }
}
</script>
```

Permet d'obtenir le même résultat que :

```
<script>
export default {
  computed: {
    foobar() {
      return this.$store.state.foobar
    },
    foobar() {
      return this.$store.state.barfoo
    }
  }
}
</script>
```

Cela permet de réduire considérablement la quantité de code lorsqu'on l'on a un grand nombre de variables à mapper. On va donc créer une fonction similaire à `mapState` qui ne va pas seulement créer de simple `computed` mais également les getters et setters nécessaires au Two-Way Binding.

```
function mapFields(fields) {
  let computeds = {}

  for (field of fields) {
    computed[field] = {
      get() {
        return this.$store.state[field]
      },
      set(value) {
        this.$store.commit('UPDATE_' + field.toUpperCase(), value)
      }
    }
  }
}
```

Vous pouvez désormais utiliser cette fonction avec le spread operator pour générer vos computed properties.

```
<script>
export default {
  computed: {
    ...mapFields(['foobar', 'barfoo'])
  }
}
</script>

<template>
  <form>
    <input type="text" v-model="foobar" />
    <input type="text" v-model="barfoo" />
  </form>
</template>
```

Ici, cela nécessite évidemment que vous disposiez des mutations pour chacun de vos variables nommée de la même façon (`UPDATE_FOOBAR` et `UPDATE_BARFOO`).

```
new Vuex.Store({
  state: {
    foobar: null,
    barfoo: null,
  },
  mutation: {
    UPDATE_FOOBAR (state, value) { state.foobar = value },
    UPDATE_BARFOO (state, value) { state.barfoo = value },
  }
})
```

Vous pouvez bien entendu complexifié cette fonction selon vos besoin et vos habitude ou en créer plusieurs correspondant à vos différents use-cases. L'idée peut être même appliquée à d'autres cas que les computed et le **two-way binding**. On peut par exemple imaginer des fonctions pour générer des méthodes ou watchers.

```
function mapWatcher(fields) {
  let watchers = {}

  for (field of fields) {
    watchers[field] = function (newValue) {
      this.$emit(`${field}_updated`, newValue)
    }
  }

  return watchers
}
```

Cette fonction permet de créer un watcher qui émettra un événement à la modification pour chaque propriété passé en argument.

```
export default {
  watch: {
    ...mapWatcher(['foobar', 'barfoo'])
  }
}
```

---
type:               "post"
title:              "Des namespace dans mon JS avec les alias Webpack Encore"
date:               "2020-07-30"
publishdate:        "2020-07-31"
draft:              true
slug:               "webpack-encore-alias-namespace"
description:        "Des namespace dans mon JS avec les alias Webpack Encore"

thumbnail:          "/images/posts/thumbnails/cool_cat.jpg"
tags:               ["Symfony", "Webpack", "Encore", "alias", "namespace"]
categories:         ["Dev", "Front", "Symfony"]

author_username:    "tjarrand"
---

Si vous travaillez avec Symfony et gérez votre base de code javascript avec Webpack Encore, j'ai aujourd'hui une petite astuce méconnue qui pourrait vous simplifier la vie : les alias Webpack.

_Note: Si vous n'utilisez pas Webpack Encore dans vos projets Symfony, vous devriez peut-être y jeter un oeil ..._

## Contexte

Par défaut, les imports de modules ES6 utilisent un chemin __relatif__ à l'emplacement du fichier.

Prenons l'arborescence suivante :

```
assets/
    js/
        core/
            Loader.js
        media/
            audio/
                AudioPlayer.js
```

Si on souhaite charger la classe `Loader` depuis `AudioPlayer`, on s'y prend comme ça :

```javascript
import Loader from '../../core/Loader.js';
```

Ce n'est pas toujours plaisant à écrire de tête et encore moins à refactorer.

## Coté back

En PHP, on est habitué aux __namespaces__, qui permettent de référencer une classe par un chemin __absolu__ qui ne dépend donc pas de l'endroit où l'on se trouve.

On commence par définir un namespace pour un chemin donné dans notre `composer.json` :

```json
"autoload": {
    "psr-4": {
        "App\\": "src/"
    }
},
```

Et on peut maintenant utiliser la classe `src/kernel.php` via le namespace `App/Kernel` partout dans notre application.

C'est ce qu'on souhaite mettre en place coté client grâce aux alias webpack !

## Les alias Webpack

Comme on configure l'autoload coté back, on peut configurer des alias coté front dans notre configuration Webpack Encore :

```javascript
//webpack.config.js
Encore
    // ...

    // Alias
    .addAliases({
        'App': `${__dirname}/assets/js`,
    })
```

On peut maintenant, depuis n'importe quel fichier, importer la classe `Loader` via un chemin absolu utilisant l'alias :

```javascript
import Loader from 'App/core/Loader.js';
```

Et voila, on a des "namespaces" pour nos modules javascript ! 🎉

## Bonus

Vous intégrez votre CSS et vos images au build directement depuis votre code JS ?

Déclarez des alias pour ceux-ci :

```javascript
//webpack.config.js
Encore
    // ...

    // Alias
    .addAliases({
        'App': `${__dirname}/assets/js`,
        'Style': `${__dirname}/assets/scss`,
        'Images': `${__dirname}/assets/images`,
    })
```

Et simplifiez-vous la vie :

```javascript
import 'Style/app.scss';
import logoPath from 'Images/logo.png';
```

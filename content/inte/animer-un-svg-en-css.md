---
type:               "post"
title:              "Animer un SVG avec CSS"
date:               "2017-10-25"
publishdate:        "2017-10-25"
draft:              false
slug:               "animer-un-svg-en-css"
description:        ""

thumbnail:          "/images/posts/thumbnails/animation.jpg"
header_img:         "/images/posts/headers/animation.jpg"
tags:               ["svg", "animation", "css", "integration"]
categories:         ["integration"]

author_username:    "adefrance"
---

> Le SVG est un langage XML utilisé pour décrire des graphiques en 2 dimensions. Il permet 3 types d'objets graphiques : des formes vectorielles, des images et du texte.  -- W3C

Dans la première partie de cet article nous allons chercher à réaliser une animation très simple. Nous allons contracter puis dilater le logo élao, pour créer un effet de rebond ou de battement.

<figure class="text-center">
    <img src="/images/posts/2017/svg/bounce.gif" alt="">
    <figcaption>Effet de battement</figcaption>
</figure>

## Avant l'animation : définir la viewbox

Le svg est limité dans l’espace par sa viewbox. Dans Illustrator ou Sketch, la viewbox correspond au canvas ou à _l’artboard_ dans lequel nous dessinons. Si un élément sort de la viewbox, par exemple lors de l'animation, il ne sera plus visible. Les dimensions de la viewbox sont donc à réfléchir avant de commencer à animer. Pour notre exemple, on choisit une viewbox de 500px sur 500px.

Les valeurs dans la viewbox indiquent son origine sur X et Y, sa largeur (`width`) et sa hauteur (`height`).

```
<svg width="500px" height="500px" viewBox="0 0 500 500">
</svg>
```

Correspond à :

<figure class="text-center">
    <img src="/images/posts/2017/svg/viewbox.svg" alt="">
</figure>

Maintenant que l'on a défini notre viewbox dans le `body` de la page, nous allons y ajouter tous les éléments SVG qui composent l'image. Dans notre cas ce sont 5 `path` exportés depuis Illustrator.

Le SVG est en place, on peut commencer à l'animer.

## Animer grâce aux transformations CSS

Les transformations CSS permettent 4 mouvements : la translation, la rotation, le redimensionnement et l’inclinaison oblique. Les transformations qui nous intéressent pour l’animation d’un SVG se situent principalement sur les axes X et Y. Pour démonstration nous allons animer le logo élao grâce à la transformation `scale()`. Tous les `transform` CSS sont animables.

### Démo: animer la transformation `scale()`
#### La théorie
La fonction `scale()` permet de modifier la taille d'un élément selon une échelle sur 2 dimensions : c'est-à-dire sur les axes X et/ou Y. Par défaut, tous les élements sont à l'échelle 1. Soit `scale(1)`.

#### Démonstration
```
.figure-1 {
  transform: scaleY(.5);
}

.figure-2 {
  transform: scale(.5);
}
```

Sur la figure 1, on rétrécit l'élément sur l'axe Y à l'échelle 0.5, cela créé une déformation. Sur la figure 2, on le rétrécit sur les 2 axes, X et Y, il conserve donc sa forme d'origine.

<figure class="text-center">
    <img src="/images/posts/2017/svg/scale.svg" alt="">
    <figcaption>Figure 1, Figure 2</figcaption>
</figure>

#### Animation
La règle CSS `@keyframes` permet de gérer les étapes de cette animation de 0% (début de l'animation) à 100% (fin de l'animation).

```
@keyframes animation {
  0%    // État au début de l'animation
  20%   // État intermédiaire, situé entre 0% et 100% de la durée de l'animation
  100%  // État à la fin de l'animation
}
ou
@keyframes animation {
  from  // État au début de l'animation
        // Pas d'étape intermédiaire
  to    // État à la fin de l'animation
}
```

Ici, nous jouons avec le transform `scale()` pour agrandir puis rétrécir les paths du logo Elao sur les deux axes X et Y et créer ainsi l'illusion d'un rebond.
```
@keyframes bounce {
  0% { transform: scale(1); }
  30% { transform: scale(1.06); }
  ...
}
```

Pour compléter l'animation, on lui ajoute une durée en seconde, `1s`. Ensuite, `infinite` indique à l'animation qu'elle doit se répéter à l'infini.

```
  animation: bounce 1s infinite;
```

Enfin, on définit l'origine du `transform: scale()`. L'axe Y dirige le `scale()` de haut en bas et l'axe X de gauche à droite, dans le sens de lecture d'une page web. Quand l'origine de la transformation (`transform-origin`) n'est pas précisée, elle se place à l'origine des 2 axes : en haut à gauche. Pour que l'animation soit centrée, on place son origine à 50% sur les 2 axes.

```
transform-origin: 50% 50%;
```
<p data-height="345" data-theme-id="0" data-slug-hash="PKNZvq" data-default-tab="css,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao heart beat" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/PKNZvq/">Elao heart beat</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Essayez de modifier l'animation en lui ajoutant une étape où vous voulez avec un `transform: scale(2)` par exemple, et déréglez le battement régulier !

## Animer des propriétés définies dans le SVG

On a vu que l'on pouvait animer un ou plusieurs éléments SVG grâce aux transformations CSS.

Il est également possible de modifier certaines propriétés d'un élément directement inscrites en attribut dans le SVG, comme la couleur de remplissage d’une forme, son opacité, la couleur et l'épaisseur de son contour.

<figure class="text-center">
    <img src="/images/posts/2017/svg/color.gif" alt="">
    <figcaption>Très simplement, nous allons inverser les couleurs du logo élao.</figcaption>
</figure>

### Démo : animer la couleur d'un élément
En SVG, la couleur d'un élément est inscrite en attribut de cet élément. Il s'agit de l'attribut `fill`.

```
<path fill="#FFFFFF" d="M149.836,206.601l18.904-24.148c2.9-3.873,2.112-9.363-1.76-12.263s-9.362-2.112-12.263,1.761l-18.904,24.148L149.836,206.601z"/>
```

```
@keyframes to-red {
  0%,
  50%,
  100% { fill: #fff; }
  25%,
  75% { fill: #ef4242; }
}
```

<p data-height="345" data-theme-id="0" data-slug-hash="NvNWxB" data-default-tab="css,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao color" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/NvNWxB/">Elao color</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## Ce qu’on ne peut pas faire en CSS

Même si l’animation en CSS offre déjà de larges possibilités d’animations, elle se confronte à certaines limites, que l'on peut toutefois pallier grâce à [SMIL](https://fr.wikipedia.org/wiki/Synchronized_Multimedia_Integration_Language) ou Javascript.

La plus flagrante est l’absence d’interactivité avec l’animation : difficile _a priori_ de faire réagir un élément svg à des événements uniquement en CSS. Impossible également de déformer complètement le `path` d’un élément.

### Trick : suivre une trajectoire courbée avec `translate()`

Impossible _a_ priori_ d'appliquer une translation à un élément autrement que selon une ligne droite ?
Ce trick est tiré du [blog de Tobias Ahlin](http://tobiasahlin.com/blog/curved-path-animations-in-css/). Il montre qu'il est possible de suivre une trajectoire non-linéaire en animant simultanément un élément et son conteneur invisible -- comme si l'on bougeait dans des sens différents deux calques superposés. En donnant la même durée aux deux animations mais en décalant leur fonction de progression (`animation-timing-function`) pour qu'elles soient désynchronisées, on obtient l'illusion que l'objet se déplace sur une courbe.

<figure class="text-center">
    <img src="/images/posts/2017/svg/curve.gif" alt="">
    <figcaption>Source : Curved path animations in css, Tobias Ahlin</figcaption>
</figure>

## Le mot de la fin

L'éventail de mouvements et d'animations possibles en CSS ouvre énormément de possibilités, lorsque cette animation est décorative et n'impacte pas le fonctionnel, car il y a très peu d'interactions possibles. L'animation en CSS est largement supportée sur les navigateurs récents (source : [CanIUse](https://caniuse.com/#search=svg)). Pour le reste, il existe d'excellentes alternatives en SMIL -- attention toutefois : pas de support sur IE ni sur Edge, ou en Javascript grâce notamment à [Snap.svg](http://snapsvg.io/) pour décomposer et recomposer des paths, gérer des événements, etc.

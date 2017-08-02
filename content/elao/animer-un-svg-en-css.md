---
type:               "post"
title:              "Animer un SVG avec CSS"
date:               "2017-07-31"
publishdate:        "2017-07-31"
draft:              false
slug:               "animer-un-svg-en-css"
description:        ""

thumbnail:          "/images/posts/thumbnails/animation.jpg"
header_img:         "/images/posts/headers/animation.jpg"
tags:               ["svg","animation","css", "integration"]
categories:         ["elao"]

author_username:    "adefrance"
---

> Le SVG est un langage XML utilisé pour décrire des graphiques en 2 dimensions. Il     permet 3 types d'objet graphiques : des formes vectorielles, des images et du texte.  -- W3C


## Avant l'animation : définir la viewbox

Le svg est limité dans l’espace par sa viewbox. Dans Illustrator ou sketch, la viewbox correspond au canvas ou à _l’artboard_ dans lequel nous dessinons. Si un élément sort de la viewbox, par exemple lors de l'animation, il ne sera plus visible. Les dimensions de la viewbox sont donc à réfléchir avant de commencer à animer.

```
<svg width="500px" height="500px" viewBox="0 0 500 500">
</svg>
```

## Animer grâce aux transformations CSS

Les transformations css permettent 4 mouvements : la translation, la rotation, la redimension et l’inclinaison oblique. Les transformations qui nous intéressent pour l’animation d’un SVG se situent principalement sur les axes x et y. Pour démonstration nous allons animer le logo élao grâce à la transformation `scale()`. Tous les `transform` CSS sont animables.

### Démo: animer la transformation `scale()`
#### La théorie
La fonction `scale()` permet permet de modifier la taille d'un élément selon une échelle sur 2 dimensions : c'est à dire sur les axes X et/ou Y. Par défaut, tous les élements sont à l'échelle 1. Soit `scale(1)`.

#### Démonstration
```
.figure-1 {
  transform: scaleY(.5);
}

.figure-2 {
  transform: scale(.5);
}
```

Sur la figure 1, on rétrécit l'élément sur l'axe Y à l'échelle 0.5, cela créé une déformation. Sur la figure 0.5, on le rétrécit sur les 2 axes, X et Y, il conserve sa forme d'origine.

<figure class="text-center">
    <img src="/images/posts/2017/svg/scale.svg" alt="">
    <figcaption>Figure 1, Figure 2</figcaption>
</figure>

#### Animation
La règle css `@keyframes` permet de gérer les étapes de cette animation de 0% (début de l'animation) à 100% (fin de l'animation).

```
@keyframes animation {
  0% { // État au début de l'animation }
  20% { // État intermédiaire, situé entre 0% et 100% de la durée de l'animation }
  100% { // État à la fin de l'animation }
}
ou
@keyframes animation {
  from { // État au début de l'animation }
  // Pas d'étape intermédiaire
  to { // État à la fin de l'animation }
}
```

Ici, nous jouons avec le transform `scale()` pour agrandir puis rétrécir les paths du logo Elao sur les deux axes X et Y et créer l'illusion d'un rebond.
```
@keyframes bounce {
  0% { transform: scale(1); }
  30% { transform: scale(1.06); }
  ...
}
```

Pour compléter l'animation, on lui ajoute une durée en seconde, `1s`. Plus loin, `infinite` indique à l'animation qu'elle doit se répéter à l'infini.

```
  animation: bounce 1s infinite;
```

Enfin, on définit l'origine du `transform: scale()`. L'axe Y dirige le `scale()` de haut en bas et l'axe X de gauche à droite, dans le sens de lecture d'une page web. Quand l'origine du `transform (`transform-origin`) n'est pas précisée, elle se place à l'origine des 2 axes : en haut à gauche. Pour que l'animation soit centrée, on place son origine à 50% sur les 2 axes.

```
transform-origin: 50% 50%;
```
<p data-height="345" data-theme-id="0" data-slug-hash="PKNZvq" data-default-tab="css,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao heart beat" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/PKNZvq/">Elao heart beat</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## Animer certaines propriétés définies dans le SVG

Il est aussi possible de modifier certaines propriétés des éléments directement inscrites en attribut dans le svg, comme la couleur de remplissage d’une forme, son opacité, la couleur et l'épaisseur de son contour.

### Démo : animer la couleur d'un élément
En SVG, la couleur d'un élément est inscrite en attribut de cet élément. Il s'agit de l'attribut `fill`.

```
<path fill="#FFFFFF" d="M149.836,206.601l18.904-24.148c2.9-3.873,2.112-9.363-1.76-12.263s-9.362-2.112-12.263,1.761l-18.904,24.148L149.836,206.601z"/>
```

```
@keyframes fill {
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

Même si l’animation en CSS offre déjà de larges possibilités d’animation, elle se confronte à certaines limites, auxquelles on peut toutefois pallier grâce à SMIL ou Javascript.

La plus flagrante est l’absence d’interactivité avec l’animation : difficile à priori de faire réagir un élément svg à des événements uniquement en CSS. Impossible également de déformer complètement le `path` d’un élément.

### Bonus
#### Suivre une trajectoire courbée

Ce trick est tiré du [blog de Tobias Ahlin](http://tobiasahlin.com/blog/curved-path-animations-in-css/). Il montre qu'il est possible de suivre une trajectoire non-linéaire en animant simultanément un élément et son conteneur invisible -- comme si l'on bougeait dans des sens différents deux calques superposés. En donnant la même durée aux deux animations mais en décalant leur `animation-timing-function` pour qu'elles soient désynchronisées, on obtient l'illusion que l'objet se déplace sur une courbe.

<figure class="text-center">
    <img src="/images/posts/2017/svg/curve.gif" alt="">
    <figcaption>Source : Curved path animations in css, Tobias Ahlin</figcaption>
</figure>


## Le mot de la fin

L'éventail de mouvements et d'animations possibles en CSS ouvre énormément de possibilités, lorsque cette animation est décorative et n'impacte pas le fonctionnel, car il y a très peu d'interaction possible. L'animation en CSS est largement supportée sur les navigateurs récents (source : [CanIUse](https://caniuse.com/#search=svg)). Pour le reste, il existe d'excellentes alternatives en SMIL -- attention toutefois : pas de support sur IE ni sur Edge, ou en Javascript grâce notamment à [Snap.svg](http://snapsvg.io/) pour décomposer et recomposer des paths, gérer des événements, etc...




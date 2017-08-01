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

Le svg est limité dans l’espace par sa viewbox. Dans Illustrator ou sketch, la viewbox correspond au canvas ou à _l’artboard_ dans lequel nous dessinons. Si un élément sort de la viewbox, par exemple lors de l'animation, il se sera plus visible. Les dimensions de la viewbox sont donc à réfléchir avant de commencer à animer.

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

Sur la figure 1, on rétrécit l'élément sur l'axe Y à l'échelle 0.5, cela créé une déformation. Sur la figure 0.5, on le rétrécit sur les 2 axes, X et Y.

<figure class="text-center">
    <img src="/images/posts/2017/svg/scale.svg" alt="">
    <figcaption>Figure 1, Figure 2</figcaption>
</figure>

#### Animation
La règle css `@keyframes` permet de gérer les étapes de cette animation de 0% (début de l'animation) à 100% (fin de l'animation).

```
@keyframes animation {
  0% { // Mon état au début de l'animation }
  20% { // Mon état intermédiaire, placé dans le temps de 1% à 99% de la durée de l'animation }
  100% { // Mon état à la fin de l'animation }
}
ou
@keyframes animation {
  from { // Mon état au début de l'animation }
  // Pas d'étape intermédiaire
  to { // Mon état à la fin de l'animation }
}
```

Ici, nous jouons avec le transform `scale()` pour agrandir puis rétrécir les paths du logo Elao sur les deux axes X et Y pour créer l'illusion d'un rebond.
```
@keyframes bounce {
  0% { transform: scale(1); }
  30% { transform: scale(1.06); }
  40% { transform: scale(0.95); }
  50% { transform: scale(1.05); }
  65% { transform: scale(0.95); }
  75% { transform: scale(1.03); }
  100% { transform: scale(1);}
}
```

Pour compléter l'animation, on lui ajoute une durée en seconde, `1s`. `infinite` indique à l'animation CSS qu'elle doit se répéter à l'infini.

```
  animation: bounce 1s infinite;
```

Enfin, on définit l'origine du `transform: scale()`. L'axe Y dirige le `scale()` de haut en bas et l'axe X de gauche à droite, dans le sens de lecture d'une page web. Quand l'origine du transform (transform-origin`) n'est pas précisée, elle se place à l'origine des 2 axes : en haut à gauche. Pour que la déformation à l'échelle soit centrée, on place son origine à 50% sur les 2 axes.

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

Même si l’animation en css offre déjà de larges possibilités d’animation, elle se confronte à certaines limites, auxquelles on peut toutefois pallier grâce à SMIL ou Javascript.

La plus flagrante est l’absence d’interactivité avec l’animation : difficile à priori de faire réagir un élément svg à des événements uniquement en css. Impossible également de déformer complètement le path d’un élément.

### Bonus
#### Animer un élément le long d'un path à l'intérieur d'un SVG avec SMIL
Il est possible d'animer directement un SVG grâce à 6 éléments :

* `animate` pour animer des attributs
* `set`, raccourci d'`animate`
* `animateMotion` déplace un élément le long d’un path
* `animateColor` modifie la valeur de couleur d’attributs
* `animateTransform` anime les attributs de transformation SVG
* `mPath` s'utilise avec l’élément `animateMotion` pour définir le path suivi pendant l'animation

Un avantage d'utiliser SMIL pour animer le SVG est que les animations fonctionnent même lorsque le SVG est embarqué en tant qu’img ou utilisé comme background-image dans CSS.

#### Démonstration : animer des éléments le long d'un `path`
D'abord, il nous un path le long duquel notre logo va glisser. Je créé le mien sur Illustrator, et je l'importe directement dans le SVG. J'ai choisi une ellipse, pour que le logo tourne à l'infini. Pour l'exercice, ce path a un `stroke`, un contour visible.

```
<path id="animation-path" fill="none" stroke="#fff" opacity=".2" stroke-width="4" stroke-miterlimit="10" d="M280.982,265.061c0,2.958-2.175,5.338-4.424,6.986c-3.435,2.516-7.6,4.006-11.684,5.071c-10.871,2.834-22.799,2.964-33.783,0.698c-4.438-0.915-8.921-2.262-12.85-4.57c-2.559-1.504-5.3-3.663-6.066-6.682c-1.786-7.033,8.05-11.117,13.115-12.748c10.604-3.415,22.46-3.799,33.413-2.085c4.765,0.746,9.554,1.938,13.919,4.03c2.924,1.401,6.087,3.355,7.614,6.339C280.705,263.016,280.982,264.028,280.982,265.061L280.982,265.061z"/>
```

Ensuite j'ai besoin de l'élément `animateMotion` pour déplacer le logo le long du path que j'ai créé. `xlink:href` me permet de cibler l'élément à animer. `dur` correspond à la durée de l'animation, `begin` à son démarrage (on pourrait remplacer `0s` par `click` pour que l'animation démarre au clic, ou encore par `click + 2s` pour qu'elle démarre 2s après le clic). `repeatCount` donne le nombre de répétition de l'animation. Enfin, `mpath` cible le path à suivre.

```
<animateMotion
  xlink:href="#animated"
  dur="3s"
  begin="0s"
  repeatCount="indefinite" >
  <mpath xlink:href="#animation-path" />
</animateMotion>
```

<p data-height="345" data-theme-id="0" data-slug-hash="MvyamN" data-default-tab="html,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao move along path" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/MvyamN/">Elao move along path</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>


## Le mot de la fin

L'éventail de mouvements et d'animations possibles en css ouvre énormément de possibilités, lorsque cette animation est décorative et n'impacte pas le fonctionnel. L'animation en css est largement supportée sur les navigateurs récents (source : [CanIUse](https://caniuse.com/#search=svg)). Pour le reste, il existe d'excellentes alternatives grâce à SMIL -- attention toutefois : pas de support sur IE ni sur Edge, ou en Javascript grâce notamment à Snap.svg.




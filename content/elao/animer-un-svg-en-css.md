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

Les transformations css permettent 4 mouvements : la translation, la rotation, la redimension et l’inclinaison oblique. Les transformations qui nous intéressent pour l’animation d’un SVG se situent principalement sur les axes x et y.

Ici, nous jouons avec scale() pour déformer les paths du logo Elao, puis rotate() pour se déplacer en rotation en définissant le centre de la lettre A comme origine.

<p data-height="345" data-theme-id="0" data-slug-hash="PKNZvq" data-default-tab="css,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao heart beat" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/PKNZvq/">Elao heart beat</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

<p data-height="345" data-theme-id="0" data-slug-hash="prjOZd" data-default-tab="css,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao rotate" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/prjOZd/">Elao rotate</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## Animer les propriétés définies dans le SVG

Il est aussi possible de modifier les propriétés des éléments directement inscrites en attribut dans le svg, comme la couleur de remplissage d’une forme, son opacité, la couleur de son contour.

<p data-height="345" data-theme-id="0" data-slug-hash="NvNWxB" data-default-tab="html,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao opacity" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/NvNWxB/">Elao opacity</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## Ce qu’on ne peut pas faire en CSS

Même si l’animation en css offre déjà de larges possibilités d’animation, elle se confronte à certaines limites, auxquelles on peut toutefois pallier grâce à SMIL ou Javascript.

La plus flagrante est l’absence d’interactivité avec l’animation : difficile à priori de faire réagir un élément svg à des événements uniquement en css. Impossible également de déformer complètement le path d’un élément, ou encore de se déplacer de façon non-linéaire, en suivant une courbe par exemple.

<p data-height="345" data-theme-id="0" data-slug-hash="MvyamN" data-default-tab="html,result" data-user="ameliedefrance" data-embed-version="2" data-pen-title="Elao move along path" class="codepen">See the Pen <a href="https://codepen.io/ameliedefrance/pen/MvyamN/">Elao move along path</a> by Amelie Defrance (<a href="https://codepen.io/ameliedefrance">@ameliedefrance</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>


## Le mot de la fin

L'éventail de mouvements et d'animations possibles en css ouvre énormément de possibilités, lorsque cette animation est décorative et n'impacte pas le fonctionnel. L'animation en css est largement supportée sur les navigateurs récents (source : [CanIUse](https://caniuse.com/#search=svg)). Pour le reste, il existe d'excellentes alternatives grâce à SMIL -- attention toutefois : pas de support sur IE ni sur Edge, ou en Javascript grâce notamment à Snap.svg.




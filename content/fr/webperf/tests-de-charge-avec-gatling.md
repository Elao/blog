---
type:           "post"
title:          "Tests de performances avec Gatling"
date:           "2016-07-28"
publishdate:    "2016-07-29"
draft:          false
slug:           "tests-de-charge-avec-gatling"
description:    "Utiliser Gatling pour tester ses applications, exemple de code et explications, comment faire des tests de performance avancés, structure des scénarios, alimentation en données de test, gestion de la session utilisateur."

language:       "fr"
thumbnail:      "/images/posts/thumbnails/clown.jpg"
header_img:     "/images/posts/headers/stickers.jpg"
tags:           ["webperf", "gatling"]
categories:     ["webperf", "analyse"]

author_username:    "gfaivre"

---

Nous utilisons de plus en plus Gatling chez ELAO pour faire nos tests de charge, le but de ceux-ci étant de pouvoir se projeter sur le comportement d'une infrastructure et/ou d'un applicatif avant de l'envoyer en production.

Les tests de performance ne sont pas nouveaux mais reste encore très (trop) peu utilisés, notamment en raison d'une certaine complexité de mise en place. Ils représentent pourtant un bon moyen d'analyser le comportement d'une application lorsque celle-ci est soumise à une grosse charge d'utilisateurs. 
J'utilise le terme générique «tests de performance» volontairement, celui-ci regroupant plusiseurs aspects que nous évoquerons dans un autre billet.

Gatling est un outils relativement récent (comparé à l'ancêtre qu'est JMeter), les premières versions datant de 2012 mais il a su se faire sa place notamment grace à sa facilité de prise en main mais également grâce aux différents outils qu'il fournit, en effet au dela de l'aspect purement «testing» 
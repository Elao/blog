---
type:               "post"
title:              "Retour sur le Forum PHP 2015"
date:               "2015-11-25"
publishdate:        "2015-11-25"
draft:              false
slug:               "forum-php-2015"
description:        "Nous étions au Forum PHP de l'AFUP, voici ce que l'on a retenu."
language:           "fr"
thumbnail:          "/images/posts/2015/haphpybirthday.jpg"
header_img:         "/images/posts/headers/elephpant_elao_family.jpg"
tags:               ["Conférence", "ForumPHP"]
categories:         ["conference"]

author_username:    "rhanna"
---

Le Forum PHP de l'<abbr title="Association Française des Utilisateurs de PHP">AFUP</abbr> a réuni au Beffroi de Montrouge du beau monde
cette année, des membres de la Core team du développement de PHP et le créateur du langage, le groenlandais Rasmus
Lerdorf.
Et pour cause ! Nous fêtons les 15 ans de l'association et les 20 ans du langage. Cerise sur le gâteau, nous fêtons
également la sortie de PHP7, une version majeure déjà plébiscitée pour les gains en performance par rapport à PHP5. 

<img src="/images/posts/2015/haphpybirthday.jpg" class="text-center">

Point d'orgue de la keynote d'ouverture, il a été diffusé en avant première mondiale la vidéo
["Haphpy Birthday"](https://www.youtube.com/watch?v=tHlCsZf3nmA),
projet collaboratif animé par notre ami [Julien](https://twitter.com/Woecifaun).
Un montage de vidéos et de photos provenant du monde entier a célébré l'amour des développeurs pour le langage PHP.
Oui en ces temps obscurs, célébrons l'amour !
L'amour pour PHP mais aussi des valeurs de partage véhiculées par ce langage Open Source.
Finalement nous avons la définition ultime de l'acronyme PHP : People Helping People.

## Les confs auxquelles nous avons assisté

Il y avait 3 tracks de conférences qui se sont déroulées sur deux journées et nous avons dû parfois faire des choix cornéliens entre des
sujets qui nous intéressent.
Voici notre retour sur les conférences auxquelles nous avons assisté.

### Taylorisme de la qualité logicielle par Jean-François Lépine

Il s'agit d'un retour d'expérience sur l'industrialisation des développements.
Nous retenons qu'il est inutile de vouloir tout automatiser.
Il faut surtout automatiser les processus qui sont à risque.
De plus il ne faut pas laisser la technique résoudre tous les problèmes.
L'Humain est au cœur de notre métier. Dans une équipe, il faut des meneurs, des gens motivés qui vont porter un projet
ou des évolutions, que ce soit au niveau technique ou en terme d'organisation. 

### Comment Ansible et Docker changent notre environnement de mise en production par Simon Constans et Maxime Thoonsen (Theodo)

Sur des projets courts de quelques semaines à quelques mois, il est important de ne pas perdre de temps pour initier la
production. Cette présentation nous a montré comment tirer parti de Ansible et Docker pour être "up" en production en
très peu de temps.

### Scrum... et après ? par Yvan Wibaux et Olivier Madre (Evaneos)

Un des cofondateurs, un architecte et un Developpeur d'Evaneos nous ont présenté comment cette start-up s'est
auto-ré-organiser.
Surtout à un moment critique où de nombreux développeurs sont arrivés en peu de temps.
Tout cela conjugué a une forte croissance et une importante demande en nouvelles fonctionnalités.
En vrac :

* Auto-organisation d'une équipe engagée
* Les développeurs ne sont pas des simples pisseurs de codes mais doivent être des développeurs-entrepreneurs
* Ré-organisation physiques des bureaux pour mieux partager et échanger
* Amélioration de la gestion des *user stories* : abandon de Jira en faveur de Trello ou de simples post-it.
* Fonctionnalités et stratégies portées par tout le monde dans la boite
* *Product Owner* partage avec les équipes plutôt que ne décide tout seul de l'orientation de son produit
* Organisation par *squad*. Les développeurs se positionnent dans les squads et sur les projets qui les intéressent.
* Encouragement aux projets personnels
* L'impact sur l'architecture technique: micro services dans containers Docker

Bref, un très bon retour d'expérience sur une tendance forte : la libéralisation de l'entreprise.

### Insuffler la culture client dans une équipe de dev par Xavier (Elao)

Par souci d'objectivité, nous nous abstriendrons de commenter cette présentation, même si nous avons trouvé ça très
bien :)
Voici le pitch :

> "L’approche agile impacte fortement la relation client avec les équipes de dev. L’approche Produit
axée autour de la valeur ajoutée des développements pour le projet a changé les relations et le fonctionnement des
équipes projets. Nous ferons le tour des grandes étapes et des écueils qui amenèrent à ce changement qui n’a qu’un seul
but : faire un projet de qualité qui réponde au besoin des utilisateurs".

Nous pouvons juste dire que nous avons eu quelques bons retours d'auditeurs disant se reconnaitre dans notre
discours. Tant mieux, nous allons dans le bon sens !

### Chronique d'un projet Driven Design par Alexandre Balmes

Très bonne introduction sur l'architecture logicielle tendance du moment : Domain Driven Design, Behavior Driven
Design...

### CQRS de la théorie à la pratique par Nicolas Le Nardou (Materiel.net)

Bon retour d'expérience sur la gestion de stock du site ecommerce materiel.net grâce au design pattern
<abbr title="Command Query Responsibility Segregation">CQRS</abbr>.

### Halte à l'anarchitecture ! par Gauthier Delamarre

Encore une conférence sur l'architecture logicielle, sujet fort lors de ce Forum PHP. Intéressant retour d'expérience
sur le rôle de l'architecte. Il nous a manqué des exemples plus concrets. Dommage également que le propos ne soit pas
plus nuancé. Par exemple que l'architecture du logiciel ne soit pas plus "collaborative".

### PHP 7 – What changed internally? par Nikita Popov
 
Nikita est l'un des développeurs de la core team de PHP. Il nous a expliqué très simplement comment PHP7 a gagné en
performance grâce à une meilleure gestion des variables.
Les [*slides*](http://fr.slideshare.net/nikita_ppv/php-7-what-changed-internally-forum-php-2015).

### Soyez spécifiques ? Un business clair et du code limpide avec RulerZ par Kévin Gomez

Pattern Specification
Présentation dynamique et claire avec des vrais morceaux de cas concrets dedans.

### L'architecture événementielle chez Meetic par Matthieu Robin et Benjamin Pineau

Kafka

### Framework agnostic for the win par Jonathan Reinink

En bref, ne coder par votre librairie pour un framework en particulier. Rendez le disponible pour tous, en le rendant
interopérable.
Dommage, c'est resté trop "en surface" et on aurait aimé plus de "retour terrain", notamment car le conférencier est
l'auteur de la librairie de gestion d'image Glide.
Car il suffit de connaitre un peu php-fig pour s'ennuyer durant cette conférence.

### Suivre ses séries avec des API par Maxime Valette

Monsieur *Vie de Merde* est venu parler plutôt de BetaSeries, de scraping, d'utilisation d'API hétéroclites et de
débrouilles. Librairie PHP très utile dans ce cas ? un simple preg_match() pour parser manuellement les sources.

### Un éléphant dans le monde des licornes par Matthieu Moquet (Blablacar)

La vie du développeur chez Blablacar entre migration vers Symfony, *code legacy* et technologies nouvelles
(ElasticSearch, Cassandra).

## Conclusion

---
type:           "post"
title:          "Notre quotidien d'équipe projet auto-organisée"
date:           "2016-12-01"
publishdate:    "2016-12-01"
draft:          false
slug:           "notre-quotidien-equipe-projet-auto-organisee"
description:    "Retour d'expérience sur la vie d'une équipe projet auto-organisée. Voici ce que nous avons mis en place progressivement, nos expérimentations, nos succès et nos échecs."
language:       "fr"
thumbnail:      "/images/posts/thumbnails/50-quick.jpg"
header_img:     "/images/posts/headers/elao_team_front.jpg"
tags:           ["agile", "user stories"]
categories:     ["methodo"]

author_username: "rhanna"

---

Chez Elao, cela fait maintenant un an que nous travaillons sur un projet aux multiples facettes. 
L'équipe est aujourd'hui constituée de quatre développeurs coté Elao, un business analyst et un Product Owner côté client.
Notre méthodologie est très inspirée de Scrum et que nous avons adapté suivant nos besoins ou selon ce qui fonctionnait le mieux.
On ne dit pas que c'est parfait et c'est cela qui fonctionne le mieux. Chaque projet a sa vérité. Voici tout simplement notre retour d'expérience.
Voici ce que nous avons mis en place progressivement, nos expérimentations, nos succès et nos échecs.

## Daily standup

Outil de synchronisation de l'équipe qu'on ne présente plus et qui dorénavant démarre en musique avec sur le célèbre hit de Bob Marley, c'est toujours plus fun
https://www.youtube.com/watch?v=F69PBQ4ZyNw

## Nos outils

- User stories dans un board Kanban sur Jira : "En tant que Admin, je peux créer une catégorie avec un titre et une couleur"
- Confluence pour consolider les spécifications. En vérité, c'est un échec pour l'instant. On doit s'améliorer à ce sujet.
- Board physique contenant :
    - Le numéro et dates début et fin du sprint
    - Le Sprint Backlog : les *users stories* sous forme de post it, son numéro Jira, l'estimation en nombre de points
    - Un Kanban avec les colonnes suivantes : Doing (en cours) / To review / Ready to demo / Demo / Done
    - Un Burn Down Chart
- Skype, avec le client, en direct et au quotidien, par échanges textes, par audio ou partage d'écran.
- Gitter, pour les besoins de discussions asynchrones de l'équipe en interne. Sinon on passe par des échanges oraux !
- Très peu ou pas du tout d'échanges emails. Car l'email c'est le mal.
- Story mapping

## Atelier

L'atelier se déroule avec un ou deux développeurs et le Product Owner (le client) durant une demie-journée.
Le but de nos ateliers est
- d'aider le Product Owner à concevoir son produit, le challenger, faire sortir les idées, décrire ou dessiner le besoin.
- trouver des solutions techniques plus simples ou moins coûteuses.

Et pour cela, il faut :
- Définir un ordre du jour (et pas toujours facile à tenir)
- Découper l'atelier en 3 parties (et entre parenthèses la durée réelle moyenne) : le prochain sprint (50%), le sprint d'après (30%), ce qui va arriver après (20%)
Le résultat de l'atelier est ce qui est écrit sur le board physique et les Post it. On prend une photo pour conserver le résultat.
Prochaine étape : écrire les Users Stories dans Jira.

On essaye d'avoir une démarche LEAN et/ou d'insuffler cette démarche à notre client pour la conception du produit.

Nous nous considérons pas comme des pisseurs de code; nous essayons de réfléchir à ce que nous faisons, pourquoi nous le faisons et nous n'hésitons à challenger le PO pour cela. 

Les ateliers sont tournants : chaque membre de l'équipe doit y participer à tour de rôle ; ceci améliore l'implication de tous les membres de l'équipe.
    
## Sprint

- Durée fixe de 2 semaines ; durant l'été, nous avons effectué un sprint d'un mois, ce fut un échec.
- Une *Cérémonie* composée de :
    - Une démo de ce qui a été fait durant le dernier sprint (30 min)
    - Rétrospective (30 à 45 min).
    - Sprint planning : 2h dans les meilleurs des cas, 3 à 4h lorsqu'il y a un peu de travail d'atelier pour finaliser les User Stories.
    Nous avons tenté plusieurs fois d'amélioré cela notamment en préparant mieux les stories en atelier.
- Récemment, nous avons mis en place avec notre client 1/2 j par sprint pour traiter la dette technique, dette technique que nous récoltons sous forme de *issues* sur *github*.
- Célérité : pas très bien ou pas du tout suivi au début ;
un problème de sous estimation d'un sprint avec trop de stories et trop de complexité (le fameux sprint d'un mois en été dont je parle plus haut) nous a fait vite recadrer cela.
- Abandon du *Sprint Goal* en cours de route, qui n'apportait pas grand chose.
    
## Definition of done

Voici la définition de fini pour le développement d'une *User Story* que nous avons fait évoluer ensemble au fil du projet.

- Test d'acceptation de la story respecté.
- Tests fonctionnels (Behat) et unitaires (Phpunit) qui passent.
- Indicateur de qualité de code *Insight* en platinum.
- Pas d'erreur majeure sur Scrutinizer, un autre indicateur de qualité de code.
- Être reviewé.
- La *PR* sur *Github* ne doit pas avoir de conflits avec la branch `master` (ou les résoudre dès que possible).
- Générer les migrations de la base de données s'il y a un changement apporté.

Autant vous dire tout de suite : un développeur qui ne respecte pas ce *DoD* prend cher ! :)

## Auto organisation et communication

L'équipe projet n'a pas de chef de projet ni de manager.
Une personne (moi) joue plus ou moins le rôle de "scrum-master" mais c'est surtout pour organiser et faire le *daily standup*, la *rétrospective*, ... 
A terme ce rôle devrait être tournant dans l'équipe.
Chaque personne de l'équipe donne son avis, peut déployer en démo ou en prod ou faire quoi que ce soit sur le projet.

Toute l'équipe participe à la conception du produit ou aux choix d'architecture logicielle via notamment les revues de design dont je parle plus bas.

Pas de personne attitrée pour discuter avec le client.
Au début, un junior demande souvent de "Peux-tu dire au client de...". On lui répond systématiquement : "Dis lui toi même".
On évite ainsi un goulot d'étranglement ; nous privilégions ainsi une relation directe avec le Product Owner.
Responsabilisation++ de chacun dans l'équipe.

Et un mot sur la transparence ?
On ne se cache rien (ou presque) : à la fois en interne ou vis à vis du client.
On informe dès qu'il y a un problème ou un changement.
Le client nous dit quand cela ne va pas ou nous fait des retours utilisateurs dès qu'il en a.
    
## Organisation du développement

- Revue de design
    - On s'est imposé au cours du projet qu'une story ne peut commencé que si une revue de design est faite par toute ou partie de l'équipe.
    Une revue de design est effectuée au tableau physique : un dessin tout simplement ou parfois plus rarement on regarde directement dans le code.
    - Le résultat est cette revue de design peut être un dessin et une liste des tâches au tableau puis reportée sur la *PR* sur *Github*
- Revue de code (qu'on ne présente plus). Parfois, on explique à l'oral ce qu'on a reporté à l'écrit et ça passe mieux et beaucoup plus vite.
- Une story ou une PR n'appartient pas à un développeur : il arrive souvent qu'une personne commence une story et un autre la termine.
- Un développeur ne doit pas toujours faire la même chose ni être le seul dans l'équipe à maitriser une technique.
Par exemple, dans notre projet, nous avions un moteur de recherche à facettes basé sur Elastic Search, chaque développeur de l'équipe a participé à une partie de sa conception.
- Pair programming (qu'on ne présente plus) : outil qui dans notre cas, nous permet de transmettre des connaissances ou résoudre plus facilement un problème en mutualisant les cerveaux !
- Nous avons également expérimenté le Mob programming. Les points positifs qu'on retient :
    - Vraiment utile lorsqu'il faut résoudre une fonctionnalité compliquée en mobilisant toute l'équipe derrière un même ordinateur. 
    - Apprendre à écouter les idées de chacun.
    - Cohésion d'équipe++
    
## Rétrospective

La rétrospective qu'on ne va pas non plus présentée en détail est pour nous un superbe outil d'amélioration continue.
Nous faison deux rétrospectives par sprint :

- Une rétrospective interne
    - Se dire des choses qui ne concernent pas forcément le client.
    - Se dire les choses même quand c'est négatif, mais toujours dans un esprit constructif.
    - Améliorer des processus internes ou des considérations techniques. Les améliorations qui émergent sont parfois partagées avec le client.
- Rétrospective avec l'équipe entière, c'est à dire avec le client.

Le résultats de ces rétrospectives ce sont des axes d'améliorations posées sur des posts it rouges ou roses qui sont revérifiés au prochain sprint. Si le problème résolu, on jette le postit sinon on le laisse.

Nous expérimentons au fur et à mesure des formats différents de rétrospectives pour casser la routine et faire émerger de nouvelles améliorations.
    
## Estimation du reste à faire

Au début, on faisait passer tout avant l'estimation du reste à faire, car "on a le temps, c'est de l'agile".
Quand le temps alloué au projet a fondu, il a bien fallu s'y mettre; un outil puissant et rapide pour cela : le *story mapping*.
Il est facile de réaliser un *Story mapping* sous forme de post it pour avoir une vision long terme et une estimation macro pour l'atterissage.

## tl,dr

- \#AutoOrganisation
- \#Communication
- \#Transparence
- \#AméliorationContinue

Résultats :
- Confiance du client dans les choix techniques que nous faisons.
- Équipe qui vit et travaille bien ensemble.
- Relation saine et win-win avec notre client.

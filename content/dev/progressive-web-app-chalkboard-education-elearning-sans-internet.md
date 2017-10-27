---
type:           "post"
title:          "Du e-learning sans internet ou presque"
date:           "2017-11-27"
publishdate:    "2017-11-27"
draft:          false
slug:           "progressive-web-app-chalkboard-education-elearning-sans-internet"
description:    "Retour d'expérience sur la progressive web app Chalkboard Education"

thumbnail:      "/images/posts/2017/"
header_img:     "/images/posts/2017/"
tags:           ["progressive web app", "service worker", "web", "mobile", "offline", "React", "Symfony", "GraphQL"]
categories:     ["dev", "Symfony", "javascript"]

author_username: "rhanna"

---

## Le contexte

Dans certains pays africains, le nombre de places disponibles à l'université est très limité.
Par conséquent de nombreux étudiants n'ont pas accès à l'université.
La startup [Chalkboard Education](https://chalkboard.education/) implantée au Ghana et en Côte d'Ivoire a pour but de
résoudre ce problème en diffusant les cours d'universités via les téléphones mobiles.
Les étudiants africains n'ont certes pas forcément le dernier modèle de smartphone ni une connexion Internet fiable mais
cela est suffisant pour accéder à la connaissance.

## Application native

Elao accompagne Chalkboard Education depuis 2015 sur la conception de son produit.
Un premier Proof Of Concept a été réalisé en [React Native](https://facebook.github.io/react-native/) avec pour résultat
une application Android déployée sur Google Play Store à destination de plusieurs centaines d'étudiants de
l'University Of Ghana.

## Progressive Web App

Avec l'émergence des [Progressive Web Apps](/fr/dev/la-revanche-du-web-par-les-progressive-web-apps/), nous avons
conseillé Chalkboard Education de revenir au web pour plusieurs raisons :

- Le public visé est majoritairement sur Android, OS pour lequel actuellement les navigateurs supportent le mieux le
Service Worker et le Web App Manifest, éléments clés du concept de Progressive Web App.
- La couverture des appareils ciblés est beaucoup plus large du fait qu'il s'agisse d'une application web.
- Le coût du développement est moins important que le développement d'applications natives pour Android et iOS.
- Le poids d'une web app est beaucoup moins important qu'une application native ce qui est un avantage pour des
populations ayant un accès limité à Internet.
- La fréquence de mise à jour est plus simple et ne dépend pas de la bonne volonté des stores d'applications.

## Back office et API avec Symfony ♥️

Back Symfony 3 pour gérer les étudiants, les cours, l'assignation des cours aux étudiants, voir la progression des étudiants pour chaque cours
Back Symfony avec controller en service
Unit test phpunit et test fonctionnel Behat

## API GraphQL ♥️

Api GraphQL au lieu de REST pour réduire le nombre de requêtes http
Laisser le front choisir les contenus qu'il souhaite

Graphql lib overblog

## Front office avec React et Redux ♥️

Web app front en SPA avec React, Redux, Redux-persist et Webpack
UI avec Material Design via la lib pour React: Material-UI

## Mobile-first et Offline-first

Check mise à jour toutes les 24h si l'utilisateur a une connexion.
Nombre de Ko à télécharger pour chaque mise à jour.
Les contenus sont stockés de différentes manières:
le contenu du cours est dans le store Redux et persisté en localStorage
les médias (images) du cours sont stockés en cache storage Service Worker
Auth User
HasUpdates
Get Courses
Fetch session content
Fetch images URL

## Le SMS pour transporter de la donnée sans Internet

Login via token unique par user envoyé par sms. Peu email. Identifiant téléphone
Validation progression par sms
Validation d'une session par internet ou par SMS. L'app front génère un code, envoyée par SMS.
Sms lu par le back.
Code décodé pour identifier l'utilisateur et la session validée

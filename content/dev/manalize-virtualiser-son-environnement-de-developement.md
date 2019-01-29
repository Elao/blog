---
type:               "post"
title:              "Virtualiser son environnement de developement avec Manalize ✨"
date:               "2019-01-29"
publishdate:        "2019-01-29"
draft:              false
summary:            true
slug:               "manalize-virtualiser-son-environnement-de-developement"
description:        "Virtualiser son environnement de developement avec Manalize ✨"

thumbnail:          "/images/posts/thumbnails/cool_cat.jpg"
tags:               ["manala", "virtualisation", "ansible", "vagrant",]
categories:         ["Dev"]

author_username:    "tjarrand"
---

Il y a certains changements, dans notre manière de travailler, qui facilite tellement la vie (coucou Git) qu'une fois adoptés, on ne se voit plus revenir en arrière.

Et bien chez nous, à élao, depuis quelques année on est passé aux environnement de dévelopmement virtuels. Et on n'envisage pas de s'en passer !

## Qu'est-ce qu'un environnement de developpement virtuel ?

C'est une machine virtuelle (que nous appellerons simple VM) qui tourne sur mon ordinateur et dans laquelle vie mon application.

L'idée c'est d'avoir tout l'environnement de mon application (version de PHP, configuration Nginx, package node ou extensions PHP particulière) installé, configuré et fonctionnel dans cette VM et ce de manière __automatique__ (c'est à dire au lancement d'une simple commande, sans intervention manuelle).

## Les avantages de la machine virtuelle

- (Re)monter et supprimer un projet sans effort sur votre machine à l'aide d'une seule commande.
- Partager le même environnement au sein d'une équipe projet.
- Développer dans des conditions et dans un contexte proche de la prod (même moteur de base de donnée, même version de PHP).
- Accèder au projet localement derrière une url intelligible. Ex : http://monprojet.vm
- Pouvoir faire tourner plusieurs projets dépendants de différentes version de PHP sur sa machine.
- Versionner tout ce contexte projet au même titre que son code source.

## Manalizer son projet

Et pour faire ça nous utilisons __[Manala](http://www.manala.io/)__, un outils petit et puissant qui permet de décrire l'environnement de notre projet sous la forme d'une configuration texte, puis de monter et lancer une VM selon cette recette.

### Pré-requis

Manala s'appuie sur _Vagrant_ et _VirtualBox_ pour créer des machines virtuelles et sur _Ansible_ pour les configurer. Veillez à installer d'abord tout les [pré-requis](https://github.com/manala/manalize#prerequisites) sur votre ordinateur.

Puis installez l'outil en ligne de commande dédié : [manalize](https://github.com/manala/manalize#installation)

### Au lancement

Pour l'exemple, nous allons créer un nouveau projet Symfony vide avec :

`symfony new --full manalize_me`

`cd manalize_me`

![](/images/posts/2019/manalize-virtualiser-son-environnement-de-developement/empty_symfony_project.png)
![](/images/posts/2019/manalize-virtualiser-son-environnement-de-developement/empty_symfony_project_browser.png)

Puis créer un environnement virtuelle Manala pour cette app :

`manalize setup . `

![](/images/posts/2019/manalize-virtualiser-son-environnement-de-developement/setup.png)

### Au quotidien

#### Créer la VM

Lorsque je viens de setup Manala sur mon projet, ou lorsque je viens de cloner ce projet, utilisant déjà Manala, sur ma machine; je dois d'abord créer la machine virtuelle :

`make setup`

#### Lancer la VM

Ensuite, je n'aurai plus qu'a lancer cette VM à chaque vois que je lance mon ordinateur et que je veux developper sur ce projet.

`vagrant up`

Mon app est disponible à l'adresse suivante : http://acme.vm

![](/images/posts/2019/manalize-virtualiser-son-environnement-de-developement/symfony_in_vm.png)

#### Entrer dans la VM

`vagrant ssh`

![](/images/posts/2019/manalize-virtualiser-son-environnement-de-developement/symfony_cli_in_vm.png)



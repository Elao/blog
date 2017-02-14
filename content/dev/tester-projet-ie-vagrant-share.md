---
type:               "post"
title:              "Tester votre projet en développement sous IE avec Vagrant share"
date:               "2017-01-25"
publishdate:        "2017-01-25"
draft:              false
slug:               ""
description:        "Tester vos projet en développement sous Internet Explorer depuis un environnement Mac OSX à l'aide de Vagrant share"
language:           "fr"
thumbnail:          ""
tags:               ["Dev", "Web"]
categories:         ["Dev", "Web"]

author_username:    "dfruit"
---

Blabla d'intro

## Prérequis

Être sous Mac OSX
Avoir VirtualBox : https://www.virtualbox.org/
Utiliser vagrant pour la virtualisation de son projet

Posséder un compte sur Atlas https://atlas.hashicorp.com/account/new

Lien de téléchargement des VM Windows de IE8 sur Win7 à Edge sur Win10 https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/

## Utiliser un clavier Mac sur votre VM Windows

Lancez sur VirtualBox votre VM fraichement téléchargée.
Pour une question de confort et de pratique, voici quelques étapes afin d'utiliser un clavier Français Apple sur Windows :

- Après avoir testé plusieurs drivers de disposition de clavier Mac pour Windows, celui que j'ai préféré utilisé est celui-ci : https://phocean.net/wp-content/uploads/2013/11/fr_mac.zip

- Dézipper le dossier et installer le pilote par le biais du setup.exe

- Accédez depuis le panneau de configuration (ou par le clic droit sur l'icône clavier pour les anciennes version Windows) aux Services de texte et langue d'entrée.

- Dans l'onglet Général, modifier le langage d'entrée par défaut par le French - Apple

## Configuration VM et Vagrant Share

Dans votre machine virtuelle de développement, il s'agit maintenant de modifier les hosts afin d'utiliser la passerelle fournie par Vagrant Share

Lancez vagrant : vagrant up

Connectez vous en ssh via la commande vagrant ssh

Modifier votre fichier de configuration, situé par exemple dans /etc/nginx/conf.d/VOTRE_FICHIER.conf pour une distribution Linux utilisant Nginx

Modifier la ligne server_name de votre configuration server :

/*server {
    server_name VOTRE_SERVER_NAME *.vagrantshare.com;
}*/

## Conclusion

connectez vous à vagrant en tapant vagrant login a la racine de votre projet

tapez ensuite vagrant share afin de récupérer l'URL générée pointant vers votre machine virtuelle

Vous pouvez maintenant accéder à votre front depuis n'importe quelle machine, virtuelle ou non

Vous pouvez à tout moment couper la passerelle avec un ctrl + c dans le terminal

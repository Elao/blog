---
type:           "post"
title:          "GAD : Github Agile Dashboard"
date:           "2017-06-28"
publishdate:    "2017-06-28"
draft:          true
slug:           "github-agile-dashboard"
description:    "Comment j'ai créer un petit outil en ligne de commande pour m'aider dans mon quotidien agile"

thumbnail:      "/images/posts/thumbnails/github-agile.jpg"
header_img:     "/mages/posts/2017/github-agile-dashboard/sprint.png"
tags:           ["agile", "scrum", "kanban", "gestion de projet", "github", "git", "node", "cli"]
categories:     ["methodo", "dev"]

author_username: "tjarrand"

---

Sur notre projet du moment, mon équipe et moi on utilise beaucoup _GitHub_ comme support agile.

De manière assez similaire à ce que [Maxime a mit en place de son coté](/methodo/gestion-projet-agile-github/).

En bref :

- Une story = une issue
- Un sprint = une milestone avec une échéance
- On inscrit l'estimation en point d'une story dans son titre :  `Ma story [3]`
- Une milestone "Backlog" contient toutes les autres stories.

Ça nous convient bien et GitHub nous fournis un aperçu de l'avancée de la milestone (et donc du sprint) en cours :

![github-milestone](/images/posts/2017/github-agile-dashboard/github-milestone.png)

Le problème, c'est que GitHub ne connais pas notre convention décrivant la valeur en point des stories et  ne peut donc pas l'exploiter.

L'avancement proposé en nombre de ticket clos n'est pas représentatif de l'avancement en terme de points, qu'on doit obtenir en additionnant les points de toutes les issues.

_Et puis un jour, on en a eu marre de faire ces totaux à la main_ 😇

## GAD, notre ligne de command agile

Alors j'ai pris un moment pour faire un petit outils en ligne de commande qui nous calculerais notre avancement en terme de points.

- On récupère la liste des issues du projet via [l'API GitHub](https://developer.github.com/v3/).
- On obtient les issues, milestone, labels, users et pull-request du projet en un seul appel HTTP !
- On extrait la valeur en point des stories à partir du titre des issues.

À partir de ces données, il est très simple de classer les stories du sprint en cours par état (_todo_, _doing_, _ready-to-review_ et _done_) et de calculer les sommes de points respectives.

En fait, puisque toutes ces données sont horodatées, on a même de quoi générer un petit __burndown chart__ !

Ainsi, dans le répertoire de notre projet, si on tape `gad sprint` on obtient :

![gad sprint](/images/posts/2017/github-agile-dashboard/sprint.png)

Par la suite, dès que nous avons identifié un besoin qui revenait souvent, on a rajouté une commande à GAD :

> Combien de points reste-t-il dans le backlog ?

![gad backlog](/images/posts/2017/github-agile-dashboard/backlog.png)

> Est-ce qu'il y a des PR que je n'ai pas encore review ?

![gad review](/images/posts/2017/github-agile-dashboard/review.png)

## Faire son propre CLI avec Node

GAD est codé en _Node_, mais de nombreux languages seront capables de répondre à une telle problématique.

Node fournit quelques outils pratiques pour réaliser rapidement un petit outil en ligne de commande :

- L'API __[ReadLine](https://nodejs.org/api/readline.html#readline_example_tiny_cli)__ qui propose quelques fonctionnalités dédiées au CLI, _out of the box_.
- Le module __[minimist](https://github.com/substack/minimist)__ propose de parser les options et arguments d'une commande à  partir d'une chaine de caractères.
- La clé __bin__ du `package.json` permet de déclarer un module en tant qu'exécutable : `"bin": { "gad": "./gad.js" }`
  La command `gad` sera automatiquement disponible une fois le module installé en global sur la machine (`npm i -g @elao/github-agile-dashboard`) !

__Note :__ lorsqu'il est exécuté, gad récupère de précieuses informations, grâce à  _git_, comme l'url du repository (`git -C . config --get remote.origin.url`) ou l'utilisateur GitHub courant (`git config --global github.user`)

## Ce qu'on en retire

`gad sprint` devient petit à petit une réflexe (comme `git status`) et nous permet d'avoir un rapide aperçu de l'avancement du sprint, directement dans le terminal, sans même avoir besoin de prendre en main la souris 😬

La première version fonctionnelle de GAD était prête après une petite après-midi de travail et accélérait déjà quelques tâches rébarbatives de notre quotidien agile. Un investissement vite "remboursé" !

GAD n'est probablement pas l'outils qui va révolutionner votre façon de travailler et multiplier la productivité de vos équipe, notamment car il à été conçu _sur-mesure_ pour nos besoin et notre façon de travailler. Mais puisqu'il est open-source, je vous propose toute de même de l'essayer et de [jettez un oeil à son code](https://github.com/Elao/github-agile-dashboard).

Et je vous invite à être attentif·ve : vous repérez une tâche que vous répétez tous les jours et ou l'humain n'a pas de valeur ajoutée ? Développez votre propre petit outils en ligne de commande pour adresser le problème et observez son adhésion par le reste de votre équipe !


---
type:           "post"
title:          "Gérer un projet AGILE avec GitHub"
date:           "2017-02-16"
publishdate:    "2017-02-16"
draft:          false
slug:           "gestion-projet-agile-github"
description:    "Retour d'expérience sur la gestion d'un projet avec GitHub."

thumbnail:      "/images/posts/thumbnails/github-agile.jpg"
header_img:     "/images/posts/headers/github-agile.jpg"
tags:           ["agile", "scrum", "kanban", "gestion de projet", "github"]
categories:     ["methodo"]

author_username: "mcolin"

---

Nombreux sont les outils de gestion de projets qu'un developpeur auxquels un développeur peut avoir affaire durant sa carrière. J'ai moi même eux affaire à plusieurs d'entre. Des solutions de ticketing (Mantis, BugZilla, Redmine, ...), des boards Kanban (Trello, Taiga), des solutions tout-en-un complexe (Jira), les forges (GitHub, GitLab) et même des solutions manuels (carnet de note, post-it).

Certaines solutions étant trop simple pour adresser tout mes besoins (Trello par exemple) ou trop complexe pour être agréable à utiliser (Jira), je retrouve souvent à jongler entre plusieurs outils qui ne sont en plus pas toujours les mêmes d'un projet à l'autre.

Mon envie était donc de trouver un moyen d'adresser tout mes besoins dans un seul outils simple et efficace. Et là, GitHub annonce de [nouvelles fonctionnalité](https://github.com/blog/2256-a-whole-new-github-universe-announcing-new-tools-forums-and-features) dont GitHub Project (oui je sais, GitLab a sortie une fonctionnalité similaire avant, mais je suis moins fan de l'ergonomie GitLab, vous pouvez d'ailleurs faire ce que je décrit dans cet article avec GitLab).

## Besoins

Les besoins que j'ai au quotidien sur un projet sont :

* Système de story/feature(AGILE) 
* Notion de sprint
* Qualification (priorité, tags/categories, estimation)
* Kanban board
* Rédaction de spécification
* Ticketing

### Les stories

J'ai representé chaque **story** par une *issue* avec un titre et une description. Dans la description j'ai ajouter les tâches à réaliser avec les petites checkbox mardown de GitHub (`- [ ] TODO`) permettant d'afficher un pourcentage de complétion de la story.

Pour chaque **sprint** j'ai créé une *milestone* auquel j'ai assigné les *issue*. Il est possible de renseigner une *due date* pouvant correspondre à la date de fin du sprint ainsi qu'une description parfaite pour le *sprint goal*. A l'interrieur de d'une *milestone* il est possible réordonner les *issues* dans l'ordre que l'on souhaite en *drag'n'drop*. Un pourcentage de complétion indique le ratio d'*issues* closes. Le filtre `no:milestone` dans la liste des *issues* permet d'afficher le backlog.

![GitHub Project](/images/posts/2017/github-milestones.jpg)

Pour la **qualification**, j'ai utilisé les *labels*. J'ai créer trois labels de priorité (prio haute rouge, prio normal jaune et prio faible vert), des label *question*, *bug*, *feature*, *enhancement* pour indiquer la nature du ticket, des labels *dev*, *inte* et *infra* pour indentifier les corps de métier impliqués ainsi que des labels de qualification métiers.

L'onglet conversation des *issues* est très pratique pour discuter de la *story* avec le *product owner*. L'interface permet simplement d'ajouter texte, lien, document et images. L'historique permet de visualiser la vie de la *story* (fermeture, réouverture, changement de priorité, commentaires, assignement, ...).

Concernant l'**estimation**, je n'ai rien trouvé dans l'interface de GitHub permettant de l'indiquer la valeur des ticket. J'ai commencé à noté la complexité dans le titre sous le format suivant juste pour me repérer :

> [5] Ma super story

Puis j'ai finalement opté pour la méthode [no estimate](https://blog.goood.pro/2014/07/25/developper-sans-faire-destimation-le-mouvement-noestimates/) estimant qu'en découpant suffisemment les *stories*, le pourcentage de *stories* complétées était suffisant pour connaître l'avancement du *sprint*.

### Le board

Fonctionalité arrivée récement, [GitHub Project](https://help.github.com/articles/about-projects/) est un *card board* de type Kanban. Vous pouvez créer plusieurs *project* créant ainsi un *board* pour chacun d'eux. Si vous avez déjà utiler Trello ou Jira vous ne serez pas perdu. L'outils est plutôt simple, vous créez des colonnes et vous y ajouter des *cards* que vous pouvez déplacer en *drag'n'drop*. Par defaut les *cards* ne contiennent qu'un champ texte. Mais il est possible de les transformer en *issues*. Vous pouvez également directement ajouter vos *issues* ou *pull requests* existantes grâce au bouton *Add cards*.

Une fois vos *issues* ajoutées au *board*, vous voyez leur titre, leur numéro, leur labels, leur état (ouvert/fermé) et les personnes assignées.

Cela manque encore un peu de fonctionnalités comme le fait de pouvoir masquer les *issues* fermé ou de pouvoir assigner ou clore les *issues* directement depuis le *board* mais je suis sur que l'équipe de GitHub ajoutera ces fonctionnalités dans l'avenir.

![GitHub Project](/images/posts/2017/github-project.jpg)

### Les spécifications

Concertant les spécifications, las d'avoir des documents Word lourds dont on ne sait jamais où est la dernier version, et toujours dans l'optique de tout centraliser sur GitHub, j'ai proposé de les écrires en *markdown* directement dans les sources du projet dans un répertoire `specs`. Ainsi elle serait versionné au même titre que les sources et il serait possible d'avoir l'historique de leur modification.

La création d'une *pull request* pour les soumettres permet d'ouvrir une discution avant de les *merger*. On peut même pousser l'idée en soumettant le code correspondant aux spécifications ajoutées ou modifiées dans la même *pull request*.

Bien sur, une telle pratique nécessite un minum de connaissances techniques (markdown, git, ...) mais en utilisant l'interface de GitHub pour créer les fichiers ces connaissances sont minimes.

Alternativement vous pouvez utiliser la fonction wiki de GitHub, plus simple, et qui dispose également d'une fonctionnalité de versioning. GitHub créé un *repository* supplémentaire pour ce wiki. Vous pouvez récupérer les sources sous forme de fichier markdown en ajoutant `.wiki` dans l'url de votre repository. En l'ajoutant aux *submodules* de votre *repository* principal vous pourrez le récupérer en même temps que vos sources.

> `git@github.com:Elao/blog.wiki.git`

Vous pouvez même ajouter un [webhook github](https://developer.github.com/v3/activity/events/types/#gollumevent) pour vous avertir à chaque modification du wiki.

## A l'utilisation

J'ai utilisé cette méthode sur un projet de 3 mois avec 1 développeur (moi), une intégratrice et un <abbr title="Product Owner">PO</abbr> client déjà familier avec GitHub.



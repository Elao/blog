---
type:               "post"
title:              "Comment empêcher les moteurs de recherche d'indexer votre app Symfony en staging ?"
date:               "2019-07-10"
publishdate:        "2019-07-10"
draft:              true
slug:               "no-index-staging-symfony"
description:        "Une courte explication pour faire en sorte que votre application, en staging, ne soit pas indexable par les robots."

thumbnail:          "/images/posts/thumbnails/cool_cat.jpg"
tags:               ["Symfony", "seo", "no-index"]
categories:         ["Dev", "Symfony", "seo"]

author_username:    "aldeboissieu"
---
L'indexation, par les robots des moteurs de recherche, des urls de staging ou de démonstration, sont des cas classiques de [#SEOHorrorStories](https://www.webrankinfo.com/dossiers/conseils/horreurs-du-seo). Cette situation est gênante, pour deux raisons : 

- L'entreprise ne souhaite probablement pas exposer à ses concurrents ou aux curieux du travail en cours,
- Le contenu relatif à l'entreprise est disponible sous plusieurs urls, induisant un fort risque de dilution de la pertinence du contenu du site "officiel", puisque celui-ci peut être proposé sur deux pages différentes (duplication de contenu). 

Voyons ensemble quelques solutions pour ne pas indexer les pages publics de nos applis, si nous n'en avons pas besoin. 

## La meilleure solution 💡: l'authentification côté serveur

Le meilleur moyen d'empêcher tout crawl des robots et visites des internautes est d'imposer une authentification côté serveur. Néanmoins, cette solution peut parfois poser des problèmes lors de la recette, car elle peut compliquer l'utilisation de certaines features, par exemple celles qui utilisent des apis. 

### Le plan B 👍 : l'en-tête de réponse HTTP

Cette instruction X-Robots-Tag indiquera aux robots de ne pas indexer la page. Attention, cette méthode ne doit pas être couplée avec une directive de disallow de l'intégralité du robots.txt, puisque dans ce cas les bots n'auront jamais accès à ce tag. 

Une des variantes est la balise meta robots noindex, [c'est une des solutions décrites par Google dans sa documentation officielle](<https://support.google.com/webmasters/answer/93710?hl=fr>). 

### Comment paramétrer ce tag sur Symfony ? 

//TODO 

## La chose à ne pas faire 🙅‍♀️ : interdire l'indexation via le robots.txt

Grâce à la directive `disallow`, on pense pouvoir empêcher les robots de visiter et d'indexer les pages de notre site. Mais ce n'est pas tout à fait l'objectif de `disallow`, qui n'empêche pas l'indexation mais le crawl. Résultat : vous pouvez retrouver des pages indexées dans les moteurs de recherche, même si le robot ne remonte ni meta description et ni title. Vous pouvez ainsi lire le fameux message : 

```A description for this result is not available because of this sites's robots.txt```

De plus, il n'est pas rare de trouver en production des robots.txt paramétrés par le staging, car ils auraient été oubliés lors de la mise en production 🙀. 

## Oups, mon staging a été indexé ...

//TODO

##Conclusion

//TODO

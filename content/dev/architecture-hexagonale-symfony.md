---
type:               "post"
title:              "L'architecture hexagonale avec Symfony"
date:               "2017-06-05"
publishdate:        "2017-06-05"
draft:              false
slug:               "architecture-hexagonale-symfony"
description:        "Présentation de l'architecture hexagonale et de son implémentation avec le framework Symfony."

thumbnail:          "/images/posts/thumbnails/hexagons.jpg"
header_img:         "/images/posts/headers/hexagons.jpg"
tags:               ["Architecture", "Conception", "Symfony", "PHP"]
categories:         ["Dev", "Symfony"]

author_username:    "mcolin"
---

# Introduction

On va commencer cet article par une petite présentation de l'**architecture héxagonale**. Egalement appelée *Ports & Adapters*, 
cette architecture présente deux caratéristiques lorsqu'on la schématise : une forme **héxagonale** (d'où son nom) et une réprésentation en **couches** ou en **onion**.

![Architecture hexagonale](/images/posts/2017/hexagonal-architecture.png)

## Une architecture hexagonale

Le grand principe de l'architecture hexagonale est la **séparation entre le code métier et l'infrastructure**. Le but est de rendre votre code métier **agnostique** de l'architecture sur laquelle votre application sera exécutée. Pour celà vous allez massivement utiliser le **design pattern adapter** et l'**inversion de dépendance**.

La forme hexagonale — qui aurait tout aussi bien pu être octogonale ou pentagonale — est la pour mettre en évidence les différentes facettes par lesquelles votre application communique avec l'exterieur via des adateurs.

L'**infrastructure** c'est tout l'environnement nécessaire à votre application sans faire parti de son coeur métier. Tout ou partie de l'infrastructure peut être remplacer sans impacter votre métier. Cela comprend — entre autres — la persistence (base de données), le système de fichier, le cache, l'applicatif externe (API, binaires, ...), les bibliothèques et framework, etc.

Le **code métier** c'est tout le code qui traduit le métier de votre client. Il s'agit des règles métier, de la logique métier, du code purement applicatif, ... Ce code est irremplaçable et constitue le coeur de votre application.

## Une architecture en couches (ou en onion)

L'autre grand principe de l'arcthiecture hexagonale est la séparation du code en couches. Le nombres de couches dépendra du la complexité de votre application et jusqu'où vous souhaitez pousser le découpage, mais vous retrouverez dans sa version complête au moins les couches suivantes (de la plus profonde à la moins profonde) :

* Domain
* Application
* Infrastructure
* Ui

L'idée est que chaque couche peut utiliser une couche inférieure mais jamais une couche supérieur, ou en tout cas pas directement.

<p class=text-center>
    <img src="/images/posts/2017/onionman.jpg" alt="Onion man" />
</p>

Les seules moyens de traverser une couche suppérieure sont les **événements**, les **exceptions** et les **adatpeurs**.

Les **événements** et les **exceptions** peuvent être lancés dans une couche inférieure et traités une couche supérieure. Quand au design pattern **adapter**, il permet de définir une interface du service donc vous avez besoin mais situé dans une couche suppérieur. L'adapteur correspondant sera implémenté dans ladite couche et l'injection de dépendances permettra d'assembler le tout en conservant le principe de séparation des couches.

Cette séparation en couches n'est pas indispensable à l'artchitecture héxagonale mais offre un cadre strict permettant de bien séparer votre votre code applicatif de votre infrastructure ainsi que les différentes parties de votre code. Une version simplifié pourrait se contenter de séparer Domain/Application de Infrastructure/UI.

## Qu'est ce qu'on met dedans ?

Dans la couche **Domain** je met le coeur métier de mon code. Sans être exhausif, cela comprend mes entités, tout ce qui concerne les règles métiers (pour lesquel vous pouvez utiliser le [pattern specification](https://github.com/maximecolin/satisfaction)), les événéments et exceptions métier.

Dans la couche **Application** je place tout mon code applicatif. Généralement cela ce traduit par des *commands* et des *queries* (cf CQRS et CommandBus). Cette couche ce situant au dessus de la couche Domain, je pourrais utiliser tout ce qui s'y trouve. Si j'ai besoin de faire appel à des composants de l'infrastructure tel que la persistance, une API ou une bibliothèque, je créérai des interfaces pour chacun de ces composants.

La couche **Infrastructure** contient majoritairement toutes les implementations des adapteurs décrit dans les interfaces des couches inférieures ainsi que tout les services nécessaires pour faire communiquer mon application avec mon infrastructure.
 
Enfin la couche **Ui** est une couche un peu particulière. Comme on peut le voir sur le schéma au début de l'article, elle occupe une facette de l'hexagone et n'entoure pas les autres couches. Il s'agit d'un sorte de couche adapteur géant qui permet à l'utilisateur de communiquer avec votre application. Elle contient donc tout ce qui touche à l'interface utilisateur comme les controlleurs, les vues, les formulaires, ... 

```
src
|- Application
|  |- Command
|  |- Query
|- Domain
|  |- Model
|  |- Specs
|- Infrastructure
|  |- Adapter
|  |- Repository
|- Ui
|  |- Action
|  |- Form
```

## Pourquoi ?

Généralement lorsque je présente cette architecture on me fait souvent les remarques suivantes : "C'est compliqué !", "Faut écrire beaucoup plus de code !" (cf. les adapteurs), "Ça prend trop de temps !", ...

Certes cette architectures est plus complexe, fait écrire un peu plus de code et demande un peu plus de reflexion qu'une artchitecture "classique" mais offre tout de même plusieurs avantages de taille.

1. Le code (en particulier le code métier) est beaucoup plus facile à tester unitairement. Il s'agit de pur PHP, débarrasser de toute relation à votre framework ou votre architecture. Toutes les dependences exterieures à votre métier sont des interfaces que vous pouvez facilement mocker ou implémenter pour vos tests. Votre code métier 100% testable unitairement.

2. Votre code métier et votre infrastructure étant complétement découplés, vous pouvez aisémenent faire évoluer votre infrastructure (changement de techno, monté de version, ...) sans jamais impacter votre code métier.

3. Vous pouvez décliner simplement l'application — par exemple en version CLI ou API — en conservant votre code metier et en changeant seulement les couches supérieures.

4. Les différentes parties de votre application étant bien découplées, vous pouvez simplement répartir leur développement sur plusieurs équipes.

5. Un code metier plus stable et pérenne.

6. En début de projet, vous pouvez mettre en place une architecture simple (persistence en mémoire/fichier, api mockée, ...) afin de vous concentrer sur la valeur ajoutée : les fonctionnalités métier.

Au final, l'investissement de départ est un peu plus grand, quoiqu'avec l'habitude pas tant, mais se regagne largement sur la durée de vie du projet tant les évolutions et la testabilité sont simplifiés.

<p class="text-center">
    <img src="/images/posts/2017/good-work-chuck-norris.jpg" alt="Good work" />
</p>

# Et Symfony dans tout ça ?

Tout d'abbord j'essaie de créer le moins possible de bundle, voir pas du tout. Cette fonctionnalité de Symfony n'est d'aucune utilité pour cette architecture, elle reste néanmoins indispensable sur certaines fonction selon la version du framework.

Symfony tend d'ailleurs vers le *no bundle* dans ses versions les plus récentes (3.3 sortie dernièrement et 4.0 à venir).

## Framework agnostique

La première régle est de bien **découpler votre code métier de votre framework**, il faut donc bannir les annotations du code que vous placer dans les couches Domain et Application.

Le mapping Doctrine se retrouvera dans des fichiers de [`yml`](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/yaml-mapping.html) ou [`xml`](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/xml-mapping.html). Pour cela, il y a une petite configuration à mettre en place dans votre fichier `config.yml` pour indiquer à Doctrine où se trouve votre mapping et vos entitées.

{{< highlight yaml >}}
doctrine:
    orm:
        mappings:
            entity:
                type: yml
                prefix: App\Domain\Model
                dir: "%kernel.root_dir%/../src/app/Resources/config/doctrine/entity"
                alias: App
                is_bundle: false
{{< /highlight >}}

Vous pouvez indiquer le type `xml` si vous préférez ce format.

Pour la validation, nous allons également utiliser des fichiers [`yml` ou `xml`](https://symfony.com/doc/current/validation.html#the-basics-of-validation). A partir de la version 3.3, Symfony permet d'indiquer dans sa configuration les répertoires qui contiennent des fichiers de validation :

{{< highlight yaml >}}
framework:
    validation:
        mapping:
            paths:
                - '%kernel.project_dir%/app/config/validation'
{{< /highlight >}}

mais en avant 3.3, il vous faudra les mettre dans un bundle qui prendra place dans `src/Infrastructure`

```
src
|- Infrastructure
   |- Bundle
      |- Resource
      |  |- config
      |     |- validation
      |        |- ObjetA.yml
      |        |- ObjetB.yml
      |- InfrastructureBundle.php
```

Une fois fait, vous pouvez désactiver les anotations de validation dans `config.yml` :

{{< highlight yaml >}}
framework:
    validation: { enable_annotations: true }
{{< /highlight >}}

Deuxièmement, **vos controlleurs ne doivent pas contenir de logique metier** qui doit être restreint à vos seules couches Domain et Application. Vous devez uniquement faire appel à votre code métier. De fait, vos controlleirs sont sensé être relativement concis.

Troisièmement, faites bien attention à **ne jamais utiliser de code provenant du framework dans votre code métier**. Si vous en avez vraiment besoin, créez une interface dans Domain ou Application puis un adatpeur dans l'Infrastructure.

Enfin, **utilisez l'injection de dépendance** de Symfony pour injecter vos adapteurs dans votre code métier.

# Conclusion

Pour conclure, je dirais que l'architecture hexagonale n'est pas une fin en soit ni l'artchitecture ultime, je la vois plus comme un cadre permettant de se contraindre à respecter le principe de séparation entre le code métier et l'infrastructure.
 
Comme tout paradigme, il a ses faiblesses et ses exceptions, mais pour l'utiliser sur tout mes projets depuis quelques années, il m'a beaucoup fait progresser vers une conception propre, solide, testable et maintenable.

---
type:           "post"
title:          "Amélirorez la pertinence de vos résultats Elastic Search grâce au score"
date:           "2017-04-24"
publishdate:    "2017-04-24"
draft:          false
slug:           "ameliorez-pertinence-resultat-elastic-search-score"
description:    "Amélirorez la pertinence de vos résultats Elastic Search grâce au score."

thumbnail:      "/images/posts/thumbnails/elasticsearch.png"
header_img:     "/images/posts/headers/elasticsearch.jpg"
tags:           ["moteur de recherche", "recherche", "elasticsearch", "pertinence", "score", "ES", "elastica"]
categories:     ["dev"]

author_username: "mcolin"

---

## ElasticSearch

[ElasticSearch](https://www.elastic.co/fr/products/elasticsearch) est un moteur de recherche très puissant mais relativement simple à mettre en place et à intégrer grâce à son API RESTful. Des bibliothèques telle que le client PHP [Elastica](http://elastica.io/) et le bundle Symfony [FOSElasticaBundle](https://github.com/FriendsOfSymfony/FOSElasticaBundle) facilite encore plus son intégration. Néanmoins la configuration fine du moteur de recherche reste assez complexe et peut faire peur au premier abord.

Je ne vais pas parler de la configuration serveur et infrastructure d'ElasticSearch qui touche plus aux performances et à la sécurité de l'outil mais plutôt m'attarder sur la configuration du moteur de recherche en lui-même, de ce qui impactera la pertinance de vos résultats.

Deux choses vont impacter les résultats de vos recherches : l'**indexation** de vos données et vos **requêtes** de recherche. Ce sont donc ces deux points qui vont être aborder dans cet article.

## Une histoire de score

Lors d'une recherche ElasticSearch, un score est calculé pour chaque document du résultat. Ce score est sencé représenter la pertinence du document afin de pouvoir ordonner les résultats. Néanmoins il ne représente que la pertinence des résultats face aux paramètres de la recherche et d'indexation.

Pour calculer ce score, ElasticSearch va faire appel à trois règles :

* La **fréquence du terme** recherché dans le document. Plus le terme est fréquent, plus élevé sera son poids.
* La **fréquence inverse du terme** à travers tout les documents. Plus le terme est fréquent, moins il aura de poids.
* La **longueur du champ** contenu le terme. Plus le champs est grand plus le poids sera faible, plus le champs est petit plus le poids sera grand.

Par defaut, ElasticSearch combine ces 3 règles pour obtinir un score, mais certaines peuvent être désactivées si elles ne vous semblent pas correspondre à vos données. Pour plus d'information sur le calcul du score, lisez la [théory du score](https://www.elastic.co/guide/en/elasticsearch/guide/current/scoring-theory.html) sur le site d'ElasticSearch.

Ces règles permettent déjà d'avoir une bonne notion de pertinences mais reste assez simple et ne prennent pas en compte le métier de vos données. Pour ajouter plus de logiques dans les scores, vous devrez introduire vos propres règles qui influenceront voire remplaceront le score 

## Indexation

L'indexation est la première étape lorsque qu'il s'agit d'optimiser la pertinence de son moteur de recherche. Car c'est grâce aux données indéxées qu'ElasticSearch va répondre à votre requête.

### Typage

ElasticSearch propose un [large choix de type](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html) pour vos données. Il a de nombreux types spécials qui n'existe pas dans les languages de programmation tels que `geo_point` ou `ip`. Il est important de typer correctement ses données car ElasticSearch dispose de traitement optimiser pour chaque type.

### Analyser

L'`analyser` est chargé d'analyser les donner a indéxer afin de les stockers de la façon la plus optimale pour les recherches. Cette partie est très importante car des données mal indéxées ne permettront pas une recherche pertinente. Il faut donc choisir avec soin l'`analyser` pour chaque type de donnée que vous souhaité indéxé. Ce choix est d'autant plus important pour les données complexe telle qu'un texte.

ElasticSearch propose [plusieurs `analysers`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html) configurable. Chaque `analyzer` est une combinaison d'un [`tokeniser`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenizers.html) chargé de découper votre donnée en tokens, de `char filters` chargés filtrer les charactères et de `token filters` chargés de filtrer les tokens.
 
Vous pouvez également [créer votre propre `analyzer`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-custom-analyzer.html) en combinant vous même `tokeniser`, `char filters` et `token filters`. Pour configurer un moteur de recherche efficace, il est donc recommandé de choisir ou créer un `analyser` adapté à chacune des données indéxées.

Par exemple une indéxation efficace d'un texte il y a quelques filtres très important à mettre en place :

* [`stemmer`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-stemmer-tokenfilter.html#analysis-stemmer-tokenfilter) : Permet une analyse linguistique de votre texte basé sur les racines des mots dans une langue donnée (Une recherche sur le mot "collection" trouvera ainsi les mots "collectionner" ou "collectionneur" par exemple).
* [`stop`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-stop-tokenfilter.html) : Permet de filtrer les *stop words*, c'est à dire les mots liaison qui ne sont pas porteur de sens et qui ne ferais que polluer l'index (en français par exemple : "de", "en", "à", "le", "la", ...).
* [`keyword_marker`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-keyword-marker-tokenfilter.html) : Permet d'indiquer des mots clés à considérer comme un seul token et non comme plusieurs mots. (Par exemple "service worker" ou "sous domaine" sont des mots clés)
* [`lowercase`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lowercase-tokenfilter.html) : Permet de tout indexé en *lowercase* afin de ne pas être semsible à la casse.

Il existe bien évidemment [des `analyser` par langue déjà tout fait](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html#french-analyzer), mais l'idée est de vous montrer qu'il est important de bien indiquer à **ElasticSearch** comment analyser vos données.

### Boost

Vous pouvez ajouter dans votre mapping des [boost](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-boost.html) sur certaines propriétés afin d'automatiquement privilégié ces propriété lors du calcul de pertinance.

```
{
  "mappings": {
    "article": {
      "properties": {
        "title": {
          "type": "text",
          "boost": 3 
        },
        "content": {
          "type": "text"
        }
      }
    }
  }
}
```

Dans cet exemple, le titre aura 3 fois plus de poids que le contenu lors du calcul de pertinence.

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention, les `boosts` indiqués au `mapping` ne fonctionneront que sur le requête de type `term`. Pour les requêtes de type `range` ou `match` par exemple, il faudra précisé les `boosts` dans la requête comme expliqué dans la suite de l'article. 
</div>

## Requêter

### Boost

Les [`boost`](https://www.elastic.co/guide/en/elasticsearch/guide/current/_boosting_query_clauses.html) permettent également d'augmenter le poids d'une clause de votre rêquete. Plus le boost est élevé, plus votre clause pèse sur le score.

Dans l'exemple suivant, nous faisons une recherche de la chaine `Foobar` sur un document ayant un titre et un contenu. Grâce aux `boost` nous pouvons donner plus d'importance aux titres qu'aux contenus.

```
{
  "query": {
    "bool": {
      "should": [
        { "match": {
          "title": { "query": "Foobar", "boost": 5 }
        }},
        { "match": {
          "content": { "query": "Foobar", "boost": 2 }
        }}
      ]
    }
  }
}
```

Vous pouvez également utiliser plusieurs `boost` sur la même propriété mais plusieurs valeurs afin d'avoir d'augmenter le score par palier.

```
{
  "query" : {
    "bool" : {
      "should" : [
        { "range" : {
          "publishedAt" : { "boost" : 5, "gte" : "<1 month ago>" }
        }},
        { "range" : {
          "publishedAt" : { "boost" : 4, "gte" : "<2 months ago>" }
        }},
        { "range" : {
          "publishedAt" : { "boost" : 3, "gte" : "<3 months ago>" }
        }}
      ]
    }
  }
}
```

### Les fonctions de score

Les fonctions de score permettent de modifier le score de vos résultat.

Il existe plusieurs types de fonctions de score :

* `script_score`
* `weight`
* `random_score`
* `field_value_factor`
* `decay functions`

Je vais surtout détailler les fonctions `script` et `decay` car ce sont celles qui permettent le plus d'implémenter une logique de pertinence. Pour les autres vous pouvez lire [la documentation sur les fonctions de score](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html#score-functions). 

#### Les scripts de score

Les scripts de score ([`script_score`](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html#function-script-score)) vous permettent de modifier score de vos résultats à partir d'un script ou d'une formule de votre choix. Vous avez accès au document dont vous modifier le score et pouvez donc utilisé l'une de ses propriétés dans le calcul. `_score` contient le score original.
 
```
"script_score" : {
    "script" : {
      "lang": "painless",
      "inline": "_score * doc['my_numeric_field'].value"
    }
}
```

Vous pouvez ainsi utiliser une valeur ou une formule métier pour calculer la pertinence de vos résultats.

#### Facteur

Cette fonction de score ([`field_value_factor`](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html#function-field-value-factor)) vous permet d'appliquer un facteur de multiplication (`factor`), une valeur par defaut (`missing`) ainsi que fonction mathématique (`modifier`) à une propriété de votre document. Plusieurs fonctions mathématique sont disponibles (`log`, `sqrt`, `ln`, ...). 

```
"field_value_factor": {
  "field": "rate",
  "factor": 1.1,
  "modifier": "sqrt",
  "missing": 1
}
```

Dans cet exemple, la pertinence d'un résultat repose sur la note du document via la formule suivante : `sqrt(1.1 * doc.rate)`.

#### Les fonctions de décroissance

Les fonctions de décroissance ([`decay function`](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html#function-decay)) sont une autre méthode pour modifier le score de vos résultats. Elles se bases sur des fonctions mathématiques pour reduire le score de vos résultats.

```
"DECAY_FUNCTION": { 
    "FIELD_NAME": { 
          "origin": "2017-04-24",
          "offset": "1d",
          "scale": "5d",
          "decay": 0.5
    }
}
```

Chaque fonction de décroissance est caratérisée par les propriétés `origin`, `offset`, `scale` et `decay`.

* `origin` est la valeur centrale à partir de laquelle sera calculer la distance de vos résultats. D'une manière générale, plus vos résultat s'éloigneront de cette valeur centrale, plus la fonction de décroissance d'appliquera.
* `offset` est la distance à partir de laquel s'appliquera votre fonction de décroissance. Avant cette distance le score ne sera pas modifié.
* `scale` est la valeur à laquelle votre fonction de décroissance appliquera la réduction souhaité.
* `decay` est la valeur de réduction de score souhaité (pourcentage de 0 à 1).

Dans l'exemple ci dessus, la valeur centrale est le 24 avril 2017 et on souhaite qu'à 6 jours (1 jour d'offset + 5 jours de scale) de cette date, soit le 18 et le 30 avril, le score soit réduit de moitié. La réduction du score des autres résultats sera calculé par la fonction de décroissance choisi. 

Il existe 3 fonctions de décroissances, [linéaire](https://fr.wikipedia.org/wiki/Fonction_lin%C3%A9aire), [exponentielle](https://fr.wikipedia.org/wiki/Fonction_exponentielle) et [gaussienne](https://fr.wikipedia.org/wiki/Fonction_gaussienne).

La fonction linéaire est une droite, le décroissance est proportionelle à la distance. Avec la fonction exponentielle, la décroissance est très forte au début et diminue rapidement avec la distance jusqu'à tendre vers zero. Avec la fonction gaussienne, la décroissance est également très forte au début mais diminue moins rapidement.

![Decay functions](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/decay_2d.png)

Les fonctions de décroissance peuvent être appliqué sur des valeurs numériques, des dates (`offset` et `scale` sont alors exprimés en durée : 5h ou 1d par exemple) ou des géopoints (`offset` et `scale` sont alors exprimés en distance : 100m ou 5km par exemple).


---
type:           "post"
title:          "Du machine learning avec PHP"
date:           "2020-05-06"
publishdate:    "2020-05-06"
draft:          false
slug:           "machine-learning-avec-php"
description:    "Du machine learning avec PHP."

thumbnail:      "/images/posts/thumbnails/pwa-general.jpg"
header_img:     "/images/posts/2016/pwa/pwa-general.jpg"
tags:           ["machine learning", "ia", "php"]
categories:     ["dev"]

author_username: "mcolin"

---

L'intelligence artificielle et le machine learning sont deux notions en vogue en ce moment mais assez abstraites pour beaucoup de développeur. Nous allons dymistifié un peu cela dans cette article et voir comment et pourquoi utiliser le machine learning.

N'étant moi même pas spécialiste, cet article est une introduction simple et basique au machine learning ainsi qu'un retour sur mes expérimentation en la matière avec PHP. Il ne couvrira donc pas la totalité de ce qu'est et de ce que permet le machine learning.

## Le machine learning

Le machine learning est une branche de l'intelligence artificielle qui consiste à nourrir un algorithme avec une quantité importante de données dans un domaine précis afin que celui ci en détermine des règles lui permettant de résoudre un problème dans ce même domaine.

Cette phase d'ingestion de données est appelé l'apprentissage ou l'entrainement. Il existe plusieurs types d'apprentissage :

* Supervisé : on fourni les données d'exemple ainsi que les réponses attendues
* Non supervisé : on ne fourni que les données d'exemple, l'agorithme tir seul des conclusions à partir des données
* Semi-supervisé : seul une partie des données d'exemple est associée à une réponse
* Par remforcement : similaire à l'apprentissage non-suppervisé mais on "récompense" la machine pour ses bonnes réponses
* Par transfert : la machine se base sur les solutions à des problèmes similaires pour trouver la réponse

Grâce au machine learning, un ordinateur peut résoudre plusieurs types de problème, parmis eux, les plus simples sont :

* Classer des éléments dans des groupes prédéfinit, il s'agit de la **classification**
* Trouver une relations entre plusieurs variables afin d'en prédire l'évolution, il s'agit de la **regression**
* Rassembler des éléments qui se ressemblent groupes homogènes, il s'agit du **clustering**

L'une de difficulté du machine learning est de déterminer quel type d'apprentissage et quel type d'algorithme correspond à son problème, puis de modèliser ses données pour correspondre aux besoins de l'algorithme.

## PHP ML

Etant moi même développeur PHP, j'ai souhaité explorer une piste me permettant de rester dans l'écosystème que je maîtrise et me concentrer le machine learning.

[PHP ML](https://github.com/php-ai/php-ml) est une bibliothèque permettant de faire du machine learning avec PHP. Elle repose sur une bibliothèque écrit en C++, [libsvm](https://www.csie.ntu.edu.tw/~cjlin/libsvm/), piloté par **PHP ML**. Le binaire est fourni pour Windows, macOS et Linux, il n'y a rien a installer en plus et nous n'aurons qu'à manipuler du **PHP**.

```
composer require php-ai/php-ml
```

Dans la suite de l'article, je vais détailler quelques types de problèmes résolvable grâce au **machine learning**, lister quelques de cas d'usages concrêts dans le monde du web et présenter un exemple avec **PHP ML**.

## La classification

La classification permet de classer des éléments dans des groupes. Il s'agit d'apprentissage supervisé, on entraîne l'algorithme avec un jeu de données associant un grand nombre d'éléments exemples à des groupes groupes. L'algorithme ainsi entrainé pourra déterminer à quel groupe appartient un nouvel élément.

Concrêment, les taches de classification peuvent être pré-machés voir complèment automatisé grâce à ce type d'algorithme.

Par exemple :

* Déterminer la langue d'un texte
* Déterminer si un message est positif ou négatif
* Classer des articles dans des catégories
* Classer des messages entre urgent et non urgent
* Répondre à une question par oui ou non

### Uses cases

Prenons l'exemple d'une application bancaire qui devrait classer les transactions en catégories (restaurant, loisir, shopping, loyer, salaire, ...).

Nous avons en entrer un fichier CSV comportant dans une première colonne le libellé des transactions et dans une seconde colonne la catégorie attendue.

```csv
"label", "category"
```

Il faut tout d'abbord charger ces données :

{{< highlight php >}}
<?php
use Phpml\Dataset\CsvDataset;

$data = new CsvDataset('data.csv', 1);
{{< /highlight >}}

Ensuite, il faut modeliser ces données sous une forme compréhensible par l'algorithme (généralement des vecteurs, des matrices, bref... des maths 😁). Pour cela on va utiliser des *transformer*.

{{< highlight php >}}
<?php
use Phpml\FeatureExtraction\{TokenCountVectorizer,TfIdfTransformer,StopWords};
use Phpml\Tokenization\WordTokenizer;

$transformers = [
    new TokenCountVectorizer(new WordTokenizer(), StopWords::factory('French')),
    new TfIdfTransformer()
];
{{< /highlight >}}

Dans notre cas, c'est la présence de certains mots qui va nous indiquer la catégorie de la transaction.

Le `TokenCountVectorizer` va extraire donc tout les mots de nos données, hors stopwords, puis compter leur occurences dans chaque libellé.

Puis, le `TfIdfTransformer` va utilise l'algorithme [TF-IDF](https://fr.wikipedia.org/wiki/TF-IDF) pour convertir cela en fréquence d'utilisation de chaque mot dans nos libellés.

> TF-IDF (term frequency–inverse document frequency), est une statistic numérique qui a pour but de reflèter à quel point un mot est important pour un document dans une collection ou un corpus.

Maintenant que nos données sont prètes, nous allons pouvoir choisir notre algorithme de classification et l'entrainé.

PHP-ML fourni trois algorithmes :

* `Phpml\Classification\SVC` qui utilise [<abbr title="Support Vector Machine">SVM</abbr>](https://fr.wikipedia.org/wiki/Machine_%C3%A0_vecteurs_de_support)
* `Phpml\Classification\NaiveBayes` qui utilise la [classification naïve bayésienne](https://fr.wikipedia.org/wiki/Classification_na%C3%AFve_bay%C3%A9sienne)
* `Phpml\Classification\KNearestNeighbors` qui utilise la [méthode des k plus proches voisins](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_k_plus_proches_voisins)

Il n'y a pas de meilleur algorithme dans l'absolut, l'efficacité de chacun dépend des données (quantité et qualité) et du problème à résoudre.

Commençons avec `SVC` :

{{< highlight php >}}
<?php
use Phpml\Classification\SVC;
use Phpml\SupportVectorMachine\Kernel;

$estimator = new SVC(Kernel::RBF, $cost = 10000);
$estimator->setVarPath(__DIR__ . '/var/model.data');
$pipeline = new Pipeline($transformers, $estimator);
{{< /highlight >}}

L'entrainement est à réalisé une fois et générera un fichier qui servira pour les prédictions.

{{< highlight php >}}
<?php
$pipeline->train($data->getSamples(), $data->getTargets());
{{< /highlight >}}

Nous pouvons ensuite faire des prédictions sur de nouvelles transactions :

{{< highlight php >}}
<?php
$pipeline->predict(['Lorem ipsum']);
{{< /highlight >}}

## La régression

La régression permet de prédire l'évolution d'une variable quantitative en fonction d'une ou plusieurs autres variables. Il s'agit d'apprentissage supervisé, on entraîne donc l'algorithme avec un jeu données contenant l'évolutions des valeurs pour la variables à prédire et les variables connues.

Le modèle de regression le plus simple est la regression linéaire. L'algorithme va placer dans un espace à n-dimenssion des points correspondant aux tuples de variables, chaque dimenssion correspondant à l'une des variables. Il trace ensuite une droite passant au plus prêt de tout les points. En fournissant n-1 variables, l'algorithme peut extrapoler la valeur de la variable manquante.

<div class="row">
  <div class="col-lg-6">
    <figure>
      <img src="/images/posts/2020/machine-learning/linear-regression.png" alt="Régression linéaire">
      <figcaption>Régression linéaire</figcaption>
    </figure>
  </div>
  <div class="col-lg-6">
    <figure>
      <img src="/images/posts/2020/machine-learning/non-linear-regression.png" alt="Régression non-linéaire">
      <figcaption>Régression non-linéaire</figcaption>
    </figure>
  </div>
</div>

Il est également possible de faire de la regression non linéaire. Le principe est le même que pour regression linéaire, sauf que la droite sera remplacé par une équation formant une courbe.

Si la regression linéaire sera plus juste pour des variables une ont une évolution proportionnel, la regression non linéaire sera utilisé pour des variables ayant une évolution exponentionelle ou cyclique par exemple.

S'il est plutôt simple de faire ce travail sur du papier pour un problème à 2 variables, il devient complexe se passer de la machine à partir de 3 variables.

### Uses cases

Prenons l'exemple d'un site d'annonce pour des locations de logement qui vous suggerait un prix en fonction des caractéristiques de votre logement en se basant sur les prix du marché.

Pour simplifier notre problème, nous allons prendre en compte que deux variables, le loyer et la superficie en m2, sur des appartements dans une zone géographique sans grosse disparité en terme de loyer.

```
18;520
78;860
18;465
53;635
...
```

On voit clairement ici une distribution linéaire malgré une hausse au dela 80m2.

<figure>
  <a href="/images/posts/2020/machine-learning/locations.svg">
    <img src="/images/posts/2020/machine-learning/locations.svg" alt="Données d'entrainement">
  </a>
  <figcaption>
    <span class="data-color a">Données d'entrainement</span>
  </figcaption>
</figure>

Essayons avec une regression linéaire :

{{< highlight php >}}
<?php
use Phpml\Dataset\CsvDataset;
use Phpml\Regression\LeastSquares;

$data = new CsvDataset(__DIR__ . '/location.csv', 1, false, ';');
$regression = new LeastSquares();
$regression->train($data->getSamples(), $data->getTargets());
{{< /highlight >}}

Si j'utilise ensuite la prédictions sur plusieurs superficies inconnues, j'obtiens le resultat suivant :

{{< highlight php >}}
<?php
foreach ([15, 20, 50, 70, 100, 115, 140, 170, 200] as $v) {
    echo $regression->predict([$v]) . "\n";
}
{{< /highlight >}}

<table class="table">
  <tr>
    <th>m2</th>
    <td>15</td>
    <td>20</td>
    <td>50</td>
    <td>70</td>
    <td>100</td>
    <td>115</td>
    <td>140</td>
    <td>170</td>
    <td>200</td>
  <tr>
  <tr>
    <th>€</th>
    <td>351</td>
    <td>409</td>
    <td>762</td>
    <td>997</td>
    <td>1350</td>
    <td>1527</td>
    <td>1821</td>
    <td>2173</td>
    <td>2526</td>
  <tr>
</table>

<figure>
  <a href="/images/posts/2020/machine-learning/locations-lineaire.svg">
    <img src="/images/posts/2020/machine-learning/locations-lineaire.svg" alt="Régression linéaire">
  </a>
  <figcaption>
    <span class="data-color a">Données d'entrainement</span>
    <span class="data-color b">Données prédites (linéaire)</span>
  </figcaption>
</figure>

Finalement on peut se rendre compte qu'au dela 80m2 l'évolution n'est peut être pas si linéaire que ça. Essayons avec une regression non-linéaire.

{{< highlight php >}}
<?php
$regression = new SVR(Kernel::POLYNOMIAL, 2);
$regression->setVarPath(__DIR__ . '/var/');
$regression->train($data->getSamples(), $data->getTargets());

foreach ([15, 20, 50, 70, 100, 115, 140, 170, 200] as $v) {
    echo $regression->predict([$v]) . "\n";
}
{{< /highlight >}}

Il peut en effet sembler logique que sur les très grandes surfaces les prix au m2 soit plus élevé car plus rare et plus luxieuse.

<figure>
  <a href="/images/posts/2020/machine-learning/location-lineaire-polynomiale.svg">
    <img src="/images/posts/2020/machine-learning/location-lineaire-polynomiale.svg" alt="Régression linéaire">
  </a>
  <figcaption>
    <span class="data-color a">Données d'entrainement</span>
    <span class="data-color b">Données prédites (linéaire)</span>
    <span class="data-color c">Données prédites (polynomiale)</span>
  </figcaption>
</figure>

## Clustering

Le clustering permet de regrouper des éléments similaire dans des groupes homogènes. A la différence de la classification, il s'agit de d'apprentissage non supervisé, les groupes ne sont pas connu à l'avance, c'est à la machine de les déterminer. L'intéret n'est pas seulement de regrouper ces éléements, mais également de faire émerger des groupes des données d'exemples.

Le clustering peut permettre par exemple de :

* Faire de la recommendation par similarité
* Segmenter des utilisateurs par comportement



https://www.youtube.com/watch?v=3FOrWMDL8CY
https://www.youtube.com/watch?v=aU7EWwLtiOg



<style type="text/css">
  figure {
    margin-bottom: 30px;
  }

  figcaption {
    text-align: center;
    font-size: 80%;
    line-height: 140%;
  }

  .table {
    width: 100%;
    margin-bottom: 30px;
  }

  .table th, .table td {
    text-align: right;
    border: 1px solid #ccc;
    padding: 0 10px;
  }

  .data-color {
    display: block;
  }

  .data-color::before {
    content: '';
    display: inline-block;
    width: 20px;
    height: 10px;
    margin-right: 5px;
    border: 1px solid #000;
  }

  .data-color.a::before { background-color: #D49D26; }
  .data-color.b::before { background-color: #7AB3E6; }
  .data-color.c::before { background-color: #589C75; }

</style>

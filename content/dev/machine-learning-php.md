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
* Semi-supervisé : seule une partie des données d'exemple est associée à une réponse
* Par remforcement : similaire à l'apprentissage non-suppervisé mais on "récompense" la machine pour ses bonnes réponses
* Par transfert : la machine se base sur les solutions à des problèmes similaires pour trouver la réponse

Grâce au machine learning, un ordinateur peut résoudre plusieurs types de problèmes, je vais vous parler de trois d'entre eux :

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

Ensuite, il faut modeliser ces données sous une forme compréhensible par l'algorithme (généralement des vecteurs, des matrices, bref... bref des maths 😁). Pour cela on va utiliser des *transformer*.

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

La **régression** permet de prédire l'évolution d'une variable quantitative en fonction d'une ou plusieurs autres variables. Il s'agit d'apprentissage supervisé, on entraîne donc l'algorithme avec un jeu de données contenant l'évolutions des valeurs pour la variables à prédire et les variables connues.

Le modèle de regression le plus simple est la **regression linéaire**. L'algorithme va placer dans un espace à n-dimenssion des points correspondant aux tuples de variables, chaque dimenssion correspondant à l'une des variables. Il trace ensuite une droite passant au plus prêt de tout les points. En fournissant n-1 variables, l'algorithme peut extrapoler la valeur de la variable manquante.

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

Il est également possible de faire de la regression non linéaire. Le principe est le même que pour regression linéaire, sauf que la droite sera remplacée par une équation formant une courbe.

Si la regression linéaire sera plus juste pour des variables une ont une évolution proportionnel, la regression non linéaire sera utilisé pour des variables ayant une évolution exponentionelle ou cyclique par exemple.

S'il est plutôt simple de faire ce travail sur du papier pour un problème à 2 variables, il devient complexe se passer de la machine à partir de 3 variables. Je vous laisse vous imaginer une droite dans un espace à 5, 6 ou 7 dimenssions.

![](/images/posts/2020/machine-learning/hard-maths.jpg)

### Cas d'usage

Prenons l'exemple d'un site d'annonce pour des locations de logement qui vous suggerait un prix en fonction des caractéristiques de votre logement en se basant sur les prix du marché.

Pour simplifier notre problème et facilité la représentation des résultat, nous allons prendre en compte que deux variables, le loyer et la superficie en m<sup>2</sup>, sur des appartements dans une zone géographique sans grosse disparité en terme de loyer.

```
18;520
78;860
18;465
53;635
...
```

On voit clairement ici une distribution linéaire malgré un léger début de courbe au dela 80m<sup>2</sup>.

<figure>
  <a href="/images/posts/2020/machine-learning/locations.svg">
    <img src="/images/posts/2020/machine-learning/locations.svg" alt="Données d'entrainement">
  </a>
  <figcaption>
    <span class="data-color a">Données d'entrainement</span>
  </figcaption>
</figure>

Essayons une regression linéaire avec l'algorithme [**LeastSquares**](https://php-ml.readthedocs.io/en/latest/machine-learning/regression/least-squares/) ([Méthode des moindres carrés](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_moindres_carr%C3%A9s)) :

{{< highlight php >}}
<?php
use Phpml\Dataset\CsvDataset;
use Phpml\Regression\LeastSquares;

$data = new CsvDataset(__DIR__ . '/locations.csv', 1, false, ';');
$regression = new LeastSquares();
$regression->train($data->getSamples(), $data->getTargets());
{{< /highlight >}}

Puis avec [**SVR**](https://php-ml.readthedocs.io/en/latest/machine-learning/regression/svr/) ([Machine à vecteurs de support](https://fr.wikipedia.org/wiki/Machine_%C3%A0_vecteurs_de_support)) :

{{< highlight php >}}
<?php
use Phpml\Dataset\CsvDataset;
use Phpml\Regression\LeastSquares;

$data = new CsvDataset(__DIR__ . '/locations.csv', 1, false, ';');
$regression = new SVR(Kernel::LINEAR);
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
    <th>m<sup>2</sup></th>
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
    <th>€ <small>LeastSquares</small></th>
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
  <tr>
    <th>€ <small>SVR(LINEAR)</small></th>
    <td>355</td>
    <td>412</td>
    <td>757</td>
    <td>987</td>
    <td>1332</td>
    <td>1504</td>
    <td>1792</td>
    <td>2136</td>
    <td>2481</td>
  <tr>
</table>

Les deux alogrithmes donnnent deux droites légèrement différentes.

<figure>
  <a href="/images/posts/2020/machine-learning/locations-lineaire.svg">
    <img src="/images/posts/2020/machine-learning/locations-lineaire.svg" alt="Régressions linéaires">
  </a>
  <figcaption>
    <span class="data-color color-1">Données d'entrainement</span>
    <span class="data-color color-2">Données prédites - LeastSquares</span>
    <span class="data-color color-3">Données prédites - SVR(LINEAR)</span>
  </figcaption>
</figure>

Finalement on peut se rendre compte qu'au dela 80m<sup>2</sup> l'évolution n'est peut être pas si linéaire que ça. Essayons avec une **régression non-linéaire**.

{{< highlight php >}}
<?php
$regression = new SVR(Kernel::POLYNOMIAL, 2);
$regression->train($data->getSamples(), $data->getTargets());

foreach ([15, 20, 50, 70, 100, 115, 140, 170, 200] as $v) {
    echo $regression->predict([$v]) . "\n";
}
{{< /highlight >}}

Il peut en effet sembler logique que sur les très grandes surfaces les prix au m<sup>2</sup> soit plus élevés car ces biens sont généralement plus rares et plus luxieux.

<figure>
  <a href="/images/posts/2020/machine-learning/locations-lineaire-polynomiale.svg">
    <img src="/images/posts/2020/machine-learning/locations-lineaire-polynomiale.svg" alt="Régression linéaire VS régression non-linéaire">
  </a>
  <figcaption>
    <span class="data-color color-1">Données d'entrainement</span>
    <span class="data-color color-2">Données prédites - SVR(POLYNOMIAL)</span>
    <span class="data-color color-3">Données prédites - SVR(LINEAR)</span>
  </figcaption>
</figure>

Il nous faudrait d'avantage de données pour determiner quel modèle colle le plus à la réalité mais nos regressions permettent tout de même d'extrapoler avec plus ou moins de précisions les données manquantes.

Evidemment dans notre cas de loyer, il faudrait également ajouter d'autres variables qui agissent sur le prix comme l'année de construction ou de rénovation, le nombre de pièces, peut être un score en fonction des commodités (ligne transport, commerces, écoles, ...) ou de la localisation. Bref vous l'aurez compris, le plus difficile va être de trouver ces variables et de leur attribuer des valeurs numériques.

### Calculer la justesse des régressions

Pour calculer la précision d'un modèle, il faut couper nos données en deux partie (80% pour l'entrainement et 20% pour les tests par exemple). `StratifiedRandomSplit` permet une distribution homogène entre données d'entrainement et  données de tests.

{{< highlight php >}}
<?php
$data = new CsvDataset(__DIR__ . '/locations.csv', 1, false, ';');
$split = new StratifiedRandomSplit($data, 0.2);
{{< /highlight >}}

On utilise la première partie pour entrainer notre algorithme, puis on compare les prédictions sur la seconde partie avec les vrais résultat :

{{< highlight php >}}
<?php
use Phpml\Metric\Regression;

function getMetrics($regression, Split $split): array {
    $regression->train($split->getTrainSamples(), $split->getTrainLabels());
    $predict = fn ($samples) => $regression->predict($samples);
    $predications = array_map($predict, $split->getTestSamples());
    $targets = $split->getTestLabels();

    return [
        'meanSqrErr' => Regression::meanSquaredError($predications, $targets),
        'meanSqrLogErr' => Regression::meanSquaredLogarithmicError($predications, $targets),
        'meanAbsErr' => Regression::meanAbsoluteError($predications, $targets),
        'medAbsErr' => Regression::medianAbsoluteError($predications, $targets),
        'maxError' => Regression::maxError($predications, $targets),
        'r2Score' => Regression::r2Score($predications, $targets),
    ];
}
{{< /highlight >}}

On fait cela avec chacune de nos régressions :

{{< highlight php >}}
<?php
print_r(getMetrics(new LeastSquares(), $split));
print_r(getMetrics(new SVR(Kernel::LINEAR), $split));
print_r(getMetrics(new SVR(Kernel::POLYNOMIAL, 2), $split));
{{< /highlight >}}

Et cela nous donne des métriques nous aidant à déterminer quelle régression est la meilleure. Sur 100 itérations j'obtiens les métriques moyennes suivante :

<table class="table">
  <tr>
    <th>Algorithme</th>
    <th><abbr title="Erreur quadratique moyenne">Erreur quad. moy.</abbr></th>
    <th><abbr title="Erreur logarithmique quadratique moyenne">Erreur log. quad. moy.</abbr></th>
    <th><abbr title="Erreur absolue moyenne">Erreur absolue moy.</abbr></th>
    <th><abbr title="Erreur aboslue médianne">Erreur absolue médiane</abbr></th>
    <th><abbr title="Erreur max">Erreur max</abbr></th>
    <th><abbr title="Score r2">Score r2</abbr></th>
  </tr>
  <tr>
    <th>LeastSquares</th>
    <td>38276</td>
    <td>0.0349</td>
    <td class="success">125</td>
    <td class="success">79</td>
    <td>889</td>
    <td>0.82</td>
  </tr>
  <tr>
    <th>SVR(LINEAR)</th>
    <td class="success">32062</td>
    <td class="success">0.0335</td>
    <td>131</td>
    <td>114</td>
    <td class="success">730</td>
    <td>0.82</td>
  </tr>
  <tr>
    <th>SVR(POLYNOM.)</th>
    <td>189201</td>
    <td>0.104</td>
    <td>340</td>
    <td>280</td>
    <td>1082</td>
    <td class="success">0.85</td>
  </tr>
</table>

On constate ici que les regressions linéaires ont donné des résultats plus justes.

## Clustering

Le clustering permet de regrouper des éléments similaires dans des groupes homogènes. A la différence de la classification, il s'agit de d'apprentissage non supervisé, les groupes ne sont pas connu à l'avance, c'est à l'algorithme de les déterminer. L'intéret n'est pas seulement de regrouper ces éléments, mais également de faire émerger des groupes à partir de nos données.

Le clustering peut permettre par exemple de :

* Faire de la recommendation
* Segmenter des utilisateurs



https://www.youtube.com/watch?v=3FOrWMDL8CY
https://www.youtube.com/watch?v=aU7EWwLtiOg



<style type="text/css">
  .row {
    display: flex;
    flex-direction: row;
    align-items: flex-end;
  }

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

  .table th.success, .table td.success {
    background-color: #1AC580;
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


  .data-color.color-1::before { background-color: #bf6969; }
  .data-color.color-2::before { background-color: #69bf69; }
  .data-color.color-3::before { background-color: #6969bf; }

  .data-color.a::before { background-color: #D49D26; }
  .data-color.b::before { background-color: #7AB3E6; }
  .data-color.c::before { background-color: #589C75; }

</style>

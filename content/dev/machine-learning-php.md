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

L'**intelligence artificielle** et le **machine learning** sont deux notions en vogue en ce moment mais assez abstraites pour beaucoup de développeurs. Nous allons dymistifier un peu cela dans cet article et voir comment et pourquoi utiliser le **machine learning**.

N'étant moi même pas spécialiste, cet article est une introduction simple et basique au machine learning ainsi qu'un retour sur mes expérimentation en la matière avec **PHP** pour des problèmatiques qui peuvent ce posé dans le monde du web. Il ne couvrira donc pas la totalité de ce qu'est et de ce que permet le **machine learning**.

## Le machine learning

Le **machine learning** est une branche de l'**intelligence artificielle** qui consiste à nourrir un algorithme avec une quantité importante de données dans un domaine précis afin que celui ci en détermine des règles lui permettant de résoudre un problème dans ce même domaine.

Cette phase d'ingestion de données est appelé l'**apprentissage** ou l'**entrainement**. Il existe plusieurs types d'apprentissage :

* **Supervisé** : on fourni les données d'exemple ainsi que les réponses attendues
* **Non supervisé** : on ne fourni que les données d'exemple, l'agorithme tir seul des conclusions à partir des données
* **Semi-supervisé** : seule une partie des données d'exemple est associée à une réponse
* **Par remforcement** : similaire à l'apprentissage non-suppervisé mais on "récompense" la machine pour ses bonnes réponses
* **Par transfert** : la machine se base sur les solutions à des problèmes similaires pour trouver la réponse

Grâce au **machine learning**, un ordinateur peut résoudre plusieurs types de problèmes, je vais vous parler de trois d'entre eux :

* **Classer** des éléments dans des groupes prédéfinit, il s'agit de la **classification**
* Trouver une relations entre plusieurs variables afin d'en **prédire** l'évolution, il s'agit de la **régression**
* **Regrouper** des éléments qui se ressemblent en groupes homogènes, il s'agit du **clustering**

L'une de difficulté du machine learning est de déterminer quel type d'apprentissage et quel type d'algorithme correspond à son problème, puis de modèliser ses données pour correspondre aux besoins de l'algorithme.

## PHP ML

Etant moi même développeur **PHP**, j'ai souhaité explorer une piste me permettant de rester dans l'écosystème que je maîtrise et me concentrer le **machine learning**.

[PHP ML](https://github.com/php-ai/php-ml) est une bibliothèque permettant de faire du **machine learning avec PHP**. Certains algorithmes sont implémentés directement en **PHP**, d'autres utilisent une bibliothèque écrit en C++, [libsvm](https://www.csie.ntu.edu.tw/~cjlin/libsvm/), piloté par **PHP ML**. Le binaire est fourni pour Windows, macOS et Linux, il n'y a rien a installer en plus et nous n'aurons qu'à manipuler du **PHP**.

```
composer require php-ai/php-ml
```

Dans la suite de l'article, je vais détailler quelques types de problèmes résolvables grâce au **machine learning**, lister quelques de cas d'usages concrêts dans le monde du web et présenter un exemple avec **PHP ML**.

## La classification

**La classification** permet de classer des éléments dans des groupes. Il s'agit d'apprentissage supervisé, on entraîne l'algorithme avec un jeu de données associant un grand nombre d'éléments exemples à des groupes prédéfinis. L'algorithme ainsi entrainé pourra déterminer à quel groupe appartient un nouvel élément.

Concrêment, les taches de classification peuvent être pré-machés voir complèment automatisé grâce à ce type d'algorithme.

Par exemple :

* Déterminer la langue d'un texte
* Déterminer si un message est positif ou négatif
* Classer des articles dans des catégories
* Classer des messages entre urgent et non urgent
* Classer des messages en spam

### Uses cases

Prenons l'exemple d'une application bancaire qui devrait classer les transactions en catégories (restaurant, loisir, shopping, loyer, salaire, ...).

<figure>
  <img src="/images/posts/2020/machine-learning/classification-chart.svg" alt="" />
</figure>

Nous avons en entrer un fichier CSV comportant dans une première colonne le libellé des transactions et dans une seconde colonne la catégorie attendue. Plus vous aurez de données, plus votre algorithme aura des chances d'être juste.

```csv
"label", "category"
"FACTURE(S) CARTE XXX DU 010113 APPLE ITUNES ST LUX 1,79EUR", "shopping"
"FACTURE(S) CARTE XXX DU 120114 CARREFOUR VILLE VILLEURBANNE", "food"
"FACTURE(S) CARTE XXX DU 190115 PAYPAL 0800 942 890", "shopping"
"VIREMENT RECU TIERS ELAO SARL ELAO - SAL012013", "wage"
"RETRAIT DAB 17/02/13 20H49 0398493 BNP PARIBAS LYON 2EME XXX", "withdrawals"
"PRELEVEMENT FREE TELECOM NUM 684936 ECH 01.04.13 REF FREE HAUTDEBIT", "multimedia"
```

Il faut tout d'abbord charger ces données :

{{< highlight php >}}
<?php
use Phpml\Dataset\CsvDataset;

$data = new CsvDataset('data.csv', 1);
{{< /highlight >}}

Ensuite, il faut modeliser ces données sous une forme compréhensible par l'algorithme (généralement des chiffres, des vecteurs, des matrices, ... bref, des maths 😁). Pour cela on va utiliser des *transformer*.

{{< highlight php >}}
<?php
use Phpml\FeatureExtraction\{TokenCountVectorizer,TfIdfTransformer,StopWords};
use Phpml\Tokenization\WordTokenizer;
use Phpml\Transformer;

$singleColumnTransformer = new class implements Transformer {
  public function fit(array $samples, ?array $targets = null): void { }
  public function transform(array &$samples, ?array &$targets = null): void {
    $samples = array_column($samples, 0);
  }
}

$transformers = [
    $singleColumnTransformer,
    new TokenCountVectorizer(new WordTokenizer(), StopWords::factory('French')),
    new TfIdfTransformer()
];
{{< /highlight >}}

Dans notre cas, c'est la présence de certains mots qui va nous indiquer la catégorie de la transaction.

`$singleColumnTransformer` va extraire la première colonne de nos données, le libellé des transactions.

Le `TokenCountVectorizer` va extraire tous les mots de nos libellés, hors stopwords, et compter leur occurence dans chaque libellé.

Puis, le `TfIdfTransformer` va utiliser l'algorithme [TF-IDF](https://fr.wikipedia.org/wiki/TF-IDF) pour convertir cela en fréquence d'utilisation de chaque mot dans nos libellés.

> TF-IDF (term frequency–inverse document frequency), est une statistic numérique qui a pour but de reflèter à quel point un mot est important pour un document dans une collection ou un corpus.

Maintenant que nos données sont prètes, nous allons pouvoir choisir notre algorithme de classification et l'entrainé.

**PHP-ML** fourni trois algorithmes :

* `Phpml\Classification\SVC`  qui est une configuration de [<abbr title="Support Vector Machine">SVM</abbr>](https://fr.wikipedia.org/wiki/Machine_%C3%A0_vecteurs_de_support) dédié à la classification
* `Phpml\Classification\NaiveBayes` qui utilise la [classification naïve bayésienne](https://fr.wikipedia.org/wiki/Classification_na%C3%AFve_bay%C3%A9sienne)
* `Phpml\Classification\KNearestNeighbors` qui utilise la [méthode des k plus proches voisins](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_k_plus_proches_voisins)

En **machine learning**, il n'y a pas de meilleur algorithme dans l'absolut, l'efficacité de chacun dépend des données (type, quantité et qualité) et du problème à résoudre.

Commençons avec `SVC` :

{{< highlight php >}}
<?php
use Phpml\Classification\SVC;
use Phpml\SupportVectorMachine\Kernel;

$estimator = new SVC();
$pipeline = new Pipeline($transformers, $estimator);
{{< /highlight >}}

On entraine tout d'abbord l'algorithme avec nos données :

{{< highlight php >}}
<?php
$pipeline->train($data->getSamples(), $data->getTargets());
{{< /highlight >}}

Nous pouvons ensuite faire des prédictions sur de nouvelles transactions :

{{< highlight php >}}
<?php
$pipeline->predict(['FACTURE(S) CARTE XXX DU 230713 DECATHLON LYON']); // => ['shopping']
{{< /highlight >}}

Nous pouvons faire de même avec `NaiveBayes`

{{< highlight php >}}
<?php
$estimator = new NaiveBayes();
$pipeline = new Pipeline($transformers, $estimator);
$pipeline->train($data->getSamples(), $data->getTargets());
$pipeline->predict(['...']);
{{< /highlight >}}

ou avec `KNearestNeighbors`

{{< highlight php >}}
<?php
$estimator = new KNearestNeighbors();
$pipeline = new Pipeline($transformers, $estimator);
$pipeline->train($data->getSamples(), $data->getTargets());
$pipeline->predict(['...']);
{{< /highlight >}}

### Calculer la justesse des classifications

Afin de déterminer **quel algorithme est le meilleur**, nous devons calculer sa précisions. Pour cela, il faut couper nos données en deux partie. Nous allons par exemple utiliser 90% de nos données pour entrainer l'algorithme et vérifier qu'il donne les bonnes prévisions pour les 10% de données restantes.

**PHP-ML** fourni la class `RandomSplit` pour cela :

{{< highlight php >}}
$data = new CsvDataset(__DIR__ . '/transactions.csv', 1, true, ',');
$split = new RandomSplit($data, 0.1); // 10% pour les tests
{{< /highlight >}}

Calculons ensuite la justesse de nos prédictions avec la classe `Accuracy` :

{{< highlight php >}}
$pipeline = new Pipeline($transformers, $estimator);
$pipeline->train($split->getTrainSamples(), $split->getTrainLabels());
$predicted = $pipeline->predict($split->getTestSamples());

echo Accuracy::score($split->getTestLabels(), $predicted) . "\n";
{{< /highlight >}}

Avec les paramètres par défaut de chaque algorithme, sur un jeu de données de 1700 transactions, j'obtiens les résultats suivants :

<table class="table">
  <tr>
    <th>algorithme</th>
    <th>score</th>
    <th>prédictions justes</th>
  <tr>
  <tr>
    <th>SVC</th>
    <td>0.43406593406593</td>
    <td>43%</td>
  </tr>
  <tr>
    <th>NaiveBayes</th>
    <td>0.95604395604396</td>
    <td class="good">95%</td>
  </tr>
  <tr>
    <th>KNearestNeighbors</th>
    <td>0.93956043956044</td>
    <td class="good">93%</td>
  </tr>
</table>

On obtiens seulement 43% de prédiction juste pour `SVC` mais plus de 90% avec `NaiveBayes` et `KNearestNeighbors`. C'est à dire que ces deux algorithmes arrivent à classer mes transactions dans la bonne catégorie plus de 9 fois sur 10.

Voyons tout de même si on ne peux pas améliorer les résultats. L'algorithme `NaiveBayes` ne dispose d'aucun paramètre, le seul moyen d'augmenter sa justesse de prédiction et d'augmenter la quantité et la qualité des données d'entrainement. Par contre `SVC` et `KNearestNeighbors` dispose tous les deux de paramètres. Essayons d'en modifier les valeurs.

### Paramètrer les algorithmes

Nous pouvons modifier [de nombreux paramètre sur l'algorithme **SVC**](https://php-ml.readthedocs.io/en/latest/machine-learning/classification/svc/).

Essayons d'intéragir avec le paramètre `$cost` :

{{< highlight php >}}
<?php
new SVC(Kernel::RBF, $cost = 10);
{{< /highlight >}}

On voit tout de suite qu'on ratrappe largement les autres algorithmes, 99% de prédictions justes c'est vraiment très bon.

<table class="table">
  <tr>
    <th>$cost</th>
    <th>score</th>
    <th>prédictions justes</th>
  </tr>
  <tr>
    <td>1</td>
    <td>0.43406593406593</td>
    <td>43%</td>
  </tr>
  <tr>
    <td>10</td>
    <td>0.94767441860465</td>
    <td>95%</td>
  </tr>
  <tr>
    <td>100</td>
    <td>0.98837209302326</td>
    <td class="good">99%</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>0.98837209302326</td>
    <td class="good">99%</td>
  </tr>
</table>

Essayons de voir si on peut faire la même chose avec `KNearestNeighbors`. Nous pouvons modifier le paramètre `$k` indiquant le nombre de plus proches voisins à analyser.

{{< highlight php >}}
<?php
new KNearestNeighbors($k = 5);
{{< /highlight >}}

Malheureusement ici, on perd clairement en justesse.

<table class="table">
  <tr>
    <th>$k</th>
    <th>score</th>
    <th>prédictions justes</th>
  </tr>
  <tr>
    <td>1</td>
    <td>0.93023255813953</td>
    <td>93%</td>
  </tr>
  <tr>
    <td>3</td>
    <td>0.92441860465116</td>
    <td>92%</td>
  </tr>
  <tr>
    <td>5</td>
    <td>0.90697674418605</td>
    <td class="bad">90%</td>
  </tr>
  <tr>
    <td>10</td>
    <td>0.88372093023256</td>
    <td class="bad">88%</td>
  </tr>
</table>

On peut également modifier le paramètre `$distanceMetric` avec l'un des différents type de distance disponible (Minkowski, Manhattan, Euclidean, Chebyshev), mais les prédictions restes moins justes qu'avec **SVC**.

En conclusion, l'algorithme **SVC** avec un *cost* à 100 est la solution qui offre les prédictions les plus justes pour notre problème.

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
    <td class="good">125</td>
    <td class="good">79</td>
    <td>889</td>
    <td>0.82</td>
  </tr>
  <tr>
    <th>SVR(LINEAR)</th>
    <td class="good">32062</td>
    <td class="good">0.0335</td>
    <td>131</td>
    <td>114</td>
    <td class="good">730</td>
    <td>0.82</td>
  </tr>
  <tr>
    <th>SVR(POLYNOM.)</th>
    <td>189201</td>
    <td>0.104</td>
    <td>340</td>
    <td>280</td>
    <td>1082</td>
    <td class="good">0.85</td>
  </tr>
</table>

On constate ici que les regressions linéaires ont donné des résultats plus justes.

## Clustering

Le **clustering** permet de regrouper des éléments similaires dans des groupes homogènes. A la différence de la **classification**, il s'agit de d'**apprentissage non supervisé**, les groupes ne sont pas connu à l'avance, c'est à l'algorithme de les déterminer. L'intéret n'est pas seulement de regrouper ces éléments, mais également de faire émerger des groupes à partir de nos données.

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
    text-align: center;
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

  .table th.good, .table td.good {
    background-color: #1AC580;
  }

  .table th.bad, .table td.bad {
    background-color: #ED4337;
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

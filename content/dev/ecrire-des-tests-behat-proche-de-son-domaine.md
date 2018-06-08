---
type:               "post"
title:              "Ecrire des tests behat proche de son domaine"
date:               "2017-11-20"
publishdate:        "2017-11-20"
draft:              false
slug:               "ecrire-des-tests-behat-proche-de-son-domaine"
description:        ""

thumbnail:          "/images/posts/thumbnails/behat.png"
header_img:         "/images/posts/headers/behat_cover.jpg"
tags:               ["Behat","Symfony","DDD"]
categories:         ["Dev", Symfony", "PHP"]

author_username:    "ndievart"
---

Il y a quelque temps nous publions un article sur [l'utilisation Behat 3 pour l'écriture des tests fonctionnels Symfony](/fr/dev/behat-3-pour-vos-tests-fonctionnels/). Depuis les choses ont beaucoup changé sur les différents projets où nous posons du Behat pour nos tests fonctionnels.
Dans cet article nous allons voir comment nous écrivons nos tests désormais en partant d'une approche Domaine.

# Cheminement

Petit à petit, sur plusieurs de nos projets ayant une grande complexité métier, l'ajout et le maintien des tests fonctionnels se sont avérés de plus en plus complexes à réaliser. Le parcours utilisateur pour se présenter dans telle ou telle situation était compliqué à mettre en place, le maintient à jour des fixtures de tests et de leurs relations indispensables ont fait que nos tests devenait difficile.

Dans de nombreux cas nous en arrivions à faire une fixture particulière pour chaque tests plutôt que de réutiliser certaines fixtures pour être totalement maître du contexte. Cependant, à chaque modification du _model_, la mise à jour de ces fixtures étaient une réelle perte de temps.

La totalité des projets chez [élao](https://www.elao.com) ont [une architecture hexagonale](/fr/dev/architecture-hexagonale-symfony) et sont orientés DDD. Nous avons donc déjà toutes les méthodes métiers nécessairent pour créer des entités pour les contextes qui nous intéressent.

{{< highlight php >}}
<?php

class Product
{
  public const TYPE_PLAN = 'plan';

  public static function createPlan(
      string $reference,
      int $price,
      float $vat,
      int $stock
  ) {
      return new self(
        self::TYPE_PLAN,
        $reference,
        $price,
        $vat,
        $stock,
        new \DateTime()
      );
  }
}
{{< /highlight >}}

Par exemple, nous avons dans notre classe métier Produit des méthodes nous permettant de créer directement des produits de différent _types_ comme des formules afin de d'abstraire certaines information inutile de faire figurer à chaque endroits du code et simplifier la création de ces derniers.
Nos _commands_ utilisent donc déjà ces méthodes pour créer des formules, et sont très flexibles pour chaque besoin différents.

Nous avons initié cette réflexion après avoir rencontrer les problèmes cité ci-dessus, mais également en explorant le code source, et notamment les tests fonctionnels du projet [Sylius](https://github.com/Sylius/Sylius/tree/master/features).

Mais arrêtons de tourner autour du pot, à quoi ressemble un test fonctionnel avec une orientation métier ?

{{< highlight gherkin >}}
Feature: Manage the plans
  As an Admin, in order to manage my plans, I need to be able to create and update the plans

  Scenario: I can update a plan
    Given the database is purged
    And there is a plan named "Premium" with a price of 100
    And the super admin "admin@example.net" is created
    And I am logged with "admin@example.net"
    When I go to this page "/fr/product/1/update/plan"
    Then the "reference" field should contain "Premium"
    And I fill in the following:
      | reference | Early bird |
      | price     | 20         |
    And I submit the form
    And I should be on this page "/fr/product"
    And the plan "Early bird" must cost 20
{{< /highlight >}}

Nous n'avons plus à _loader_ des fixtures et à les maintenir, maintenant, nous pouvons utiliser un même _step_ (`And there is a plan called "AAAA" with a price of DDD`) pour plusieurs de nos tests fonctionnels, ce qui nous permet de créer des formules dans divers contextes.

> Comment mettre tout cela en place avec Behat ?

# Mise en place

Tout d'abord, nous avons besoin d'installer Behat en _dev-dependencies_ de notre composer.json

{{< highlight json >}}
"require-dev": {
    "behat/behat": "^3.1",
    "behat/mink-browserkit-driver": "^1.3",
    "behat/mink-extension": "^2.2",
    "behat/symfony2-extension": "^2.1",
    "webmozart/assert": "^1.1"
}
{{< /highlight >}}

Le point d'entrée de Behat est le fichier `behat.yml.dist` à la racine de notre projet. Afin de déporter l'ensemble de la logique de notre code Behat dans un seule et même endroit, notre fichier `behat.yml.dist` ne sert qu'à importer notre fichier de configuration déporter dans un autre répertoire:


{{< highlight yaml >}}
imports:
  - features/Behat/Resources/config/default.yml
{{< /highlight >}}

L'architecture des repertoires nos tests fonctionnels est la suivante:

```
- features/
    - Behat/ contient le code de nos proxys métier et nos contextes
    - product/ contient les tests .features sur les produits
    - user/ contient les tests .features sur les utilisateurs
    - ...
- src/ code métier
```

Le point d'entrée est donc le repertoire `features/` dans lequel nous stockons à la fois nos tests mais aussi nos services et contextes.

Expliquons ensuite comment réaliser un step comme celui que nous avons vu plus haut qui permet la création d'une formule sans passer par des fixtures.

Nous allons donc créer un _Manager_ qui nous permettra d'appeler nos méthodes de création de produits, de modifier des paramètres, d'appeler les _repositories_ pour persister en base de données ce qui doit l'être etc...

> features/Behat/Manager/ProductManager.php

{{< highlight php >}}
<?php

namespace App\Tests\Behat\Manager;

class ProductManager
{
    private $productRepository;

    public function __construct(
        ProductRepositoryInterface $productRepository
    ) {
        $this->productRepository = $productRepository;
    }

    public function createPlan(string $reference, int $price): void
    {
         $plan = Product::createPlan(
            $reference,
            $price,
            20,
            100
        );

        $this->productRepository->add($plan);
    }
}
{{< /highlight >}}

Ce _Manager_ utilise la méthode static que nous avons vu précédemment qui est également utilisé dans notre code métier. Nous aurions également pu utiliser notre _Command Handler_ métier qui permet de créer une formule et donc ne pas à avoir à dupliquer certaines parties de notre code, mais pour des raisons de simplifications, nous partirons sur cet exemple.

Nous allons ensuite créer une service qui va nous service de _proxy_, sous la forme d'un passe-plat, pour pouvoir appeler notre _Manager_ dans nos contextes Behat.

> features/Behat/Proxy/ProductProxy.php

{{< highlight php >}}
<?php

namespace App\Tests\Behat\Proxy;

class ProductProxy
{
    private $productManager;

    public function __construct(
        ProductManager $productManager
    ) {
        $this->productManager = $productManager;
    }

    public function getProductManager(): ProductManager
    {
         return $this->productManager;
    }
}
{{< /highlight >}}

Et enfin, nous allons créer un _ProductContext_ afin de créer notre step Gherkin

> features/Behat/Context/ProductProxy.php

{{< highlight php >}}
<?php

namespace App\Tests\Behat\Context;

use Behat\Behat\Context\Context;

class ProductContext implements Context
{
    private $productProxy;

    public function __construct(
        ProductProxy $productProxy
    ) {
        $this->productProxy = $productProxy;
    }

    /**
     * @Given there is a plan named :reference with a price of :price
     */
    public function createPlan(string $reference, int $price): void
    {
        $this->productProxy
            ->getProductManager()
            ->createPlan($reference, $price)
        ;
    }
}
{{< /highlight >}}

Ensuite, nous avons plus qu'à modifier notre fichier `default.yml` afin de lui spécifier l'utilisation du nouveau contexte que nous venons de créer

> features/Behat/Resources/config/default.yml

{{< highlight yaml >}}
default:
    extensions:
        Behat\Symfony2Extension:
            kernel:
               env: test
               bootstrap: 'vendor/autoload.php'
        Behat\MinkExtension:
            base_url:  'http://localhost:8000/app_test.php'
            sessions:
                default:
                    symfony2: ~
    suites:
        default:
            contexts:
                - App\Tests\Behat\Context\ProductContext:
                    - '@App\Tests\Behat\Proxy\ProductProxy'
{{< /highlight >}}

Nous sommes donc maintenant en mesure d'utiliser notre _step_ dans nos features Behat et créer des formules facilement, sans utiliser de fixtures mais aussi en réutilisant notre code métier. Ce qui permet que si ce code métier évolue, nos tests suivent également.

Maintenant que nos services sont en place, nous pouvons réaliser de nouveaux step qui nous permettent de tester simplement le fonctionnement de la plateforme.
Nous allons réaliser le _step_ précédent `And the plan "Early bird" must cost 20` qui nous permet de tester que notre formule a bien été modifié au bon prix.

Nous modifions alors notre _Manager_ afin d'y ajouter la fonction de récupération d'une formule via le repository

{{< highlight php >}}
<?php

class ProductManager
{
    // ...

    public function getPlanByReference(string $reference): Product
    {
        return $this->productRepository
            ->getPlanByReference($reference)
        ;
    }
}
{{< /highlight >}}

Nous pouvons donc récupérer notre formule dans notre _ProductContext_ et tester que son prix a bien été modifié comme nous le souhaitons

{{< highlight php >}}
<?php

use Behat\Behat\Context\Context;
use Webmozart\Assert\Assert;

class ProductContext implements Context
{
    // ..

    /**
     * @Given the plan :reference must cost :price
     */
    public function thePlanMustCost(string $reference, int $price)
    {
        $plan = $this->productProxy
            ->getProductManager()
            ->getPlanByReference($reference)
        ;

        Assert::same($plan->getPrice(), $price);
    }
}
{{< /highlight >}}

Et c'est tout, pas besoin de _parser_ le _DOM_ pour retrouver la valeur du prix de la formule afin d'identifier si elle est égale à A ou B, il suffit de récupérer la formule depuis la base de données et tester que son prix a bien été modifée par notre nouvelle valeur. Cela rend les _steps_ Behat beaucoup plus lisibles.

# Amélioration

Au fur et à mesure de l'utilisation de ce système, vous vous rendrez compte qu'il manque quelque chose... En effet, les différents _steps_ sont distincts les uns des autres, ne communiquant pas, ils ne peuvent pas utiliser les valeurs des autres _steps_
Imaginons que vous souhaitez créer une formule "Early bird" et que celle-ci soit disponible uniquement jusqu'à une certaine date. Pour réaliser ce _step_ il vous faudra donc soit créer une nouveau _step_ qui permet de créer une formule avec une référence, un prix et une date de fin de disponibilité. Cela nous fait dupliquer une partie du code précédent et ce n'est pas forcément pertinent.

Pour éviter cela, il est intéresant de pouvoir récupérer un élément du _step_ précédent dans le _step_ suivant afin de modifier certaines valeurs ou des rajouter des conditions sur celles-ci.

Afin de réaliser cette tâche, nous avons ajouter un service qui sert de receptacle de données entre nos _steps_ et qui nous permet de piocher les données des _steps_ précédent.
Ce _Storage_ contient simplement un tableau indexer par type de donnée stockée et nous offre l'accès à un getter et un setter pour récupérer ou écraser la donnée.

> features/Behat/Storage/Storage.php

{{< highlight php >}}
<?php

class Storage
{
    /** @var array */
    private $storage;

    public function set(string $name, $value): void
    {
        $this->storage[$name] = $value;
    }

    public function get($name)
    {
        return $this->storage[$name] ?? null;
    }
}
{{< /highlight >}}

On peut ensuite, injecter ce storage à notre ProductProxy et on pourra de ce fait, piocher dans les données pour les modifier

{{< highlight php >}}
<?php

namespace App\Tests\Behat\Proxy;

class ProductProxy
{
    private $productManager;
    private $storage

    public function __construct(
        ProductManager $productManager,
        Storage $storage
    ) {
        $this->productManager = $productManager;
        $this->storage = $storage;
    }

    // ...

    public function getStorage(): Storage
    {
         return $this->storage;
    }
}
{{< /highlight >}}

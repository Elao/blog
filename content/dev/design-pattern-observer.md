---
type:           "post"
title:          "Le Design Pattern 'Observer'"
date:           "2017-11-24"
publishdate:    "2017-11-24"
draft:          false
slug:           "design-pattern-observer"
description:    "Dans le cadre de notre série consacrée aux Design Patterns, nous nous intéressons aujourd'hui au DP 'Observer'"

thumbnail:      "/images/posts/thumbnails/big-brother.png"
header_img:     "/images/posts/headers/big-brother.png"
tags:           ["Design Pattern", "Conception"]
categories:     ["Dev", "Design Pattern"]

author_username:    "xavierr"

---

Aujourd'hui, je vous propose de nous intéresser au Design Pattern `Observer` qui va nous permettre de réagir à des événements. Ce pattern est aussi parfois appelé `Publisher/Subscriber`.

<!--more-->

## Classification

Le pattern `Observer` appartient aux Design patterns dits "comportementaux" (`Behavior`)

## Définition (GoF)

> The observer pattern is a design pattern that defines a link between objects so that when one object's state changes, all dependent objects are updated automatically. This pattern allows communication between objects in a loosely coupled manner.

En résumé, le DP `Observer` est utile lorsqu'un ou plusieurs objets (les _observateurs_) doivent réagir au changement d'état d'un objet donné (le _sujet_).

## Diagramme des participants

<p class="text-center">
    {{< figure class="text-center" src="/images/posts/design-pattern/behavior-observer.png" alt="Le Design Pattern 'Observer'">}}
</p>

On distingue dans ce diagramme :

* le sujet observé (`Subject`, ou bien encore `Publisher`) 
* et ses observateurs (`Observer`, ou bien encore `Subscriber`)

## Exemple concret

Pour illustrer ce Design Pattern, nous partons du cas d'utilisation suivant, très fréquent dans les applications d'e-commerce : lorsqu'une commande est finalisée par un client, un mail de confirmation doit être envoyé au client et les stocks des produits commandés doivent être mis à jour.

Dans l'exemple qui suit,

* un service `CheckoutOrderHandler` est responsable de finaliser la commande : c'est le **Sujet observé**.

* plusieurs services réagissent à la finalisation d'une commande (`OrderConfirmationMailer`, `StockUpdater`, etc.) : ce sont les **observateurs**.

### Les interfaces `Subject` et `Observer`

Commençons par introduire deux interfaces correspondant respectivement au sujet observé et aux observateurs (aucune surprise, les méthodes exposées par ces deux interfaces correspondent à celles qui figurent dans le diagramme des participants) : 

{{< highlight php >}}
<?php
/**
 * The subject interface
 */
interface Subject {
    public function notifyObservers(Order $order);
    public function addObserver(Observer $observer);
    public function removeObserver(Observer $observer);
}

/**
 * The observer interface
 */
interface Observer {
    public function notify(Order $order);
}
{{< /highlight >}}

<div class="aside-note">
    Noter que la SPL (Standard PHP Library) propose deux interfaces assez similaires : 

    <ul class="fragment">
        <li><a href="http://php.net/manual/en/class.splobserver.php" target="_blank">http://php.net/manual/en/class.splobserver.php</a></li>
        <li><a href="http://php.net/manual/en/class.splsubject.php" target="_blank">http://php.net/manual/en/class.splsubject.php</a></li>
    </ul>
</div>

### Le sujet observé : `CheckoutOrderHandler`

Commençons par présenter une classe métier modélisant très sommairement une commande (c'est cette classe métier que manipulera notre sujet `CheckoutOrderHandler`) :

{{< highlight php >}}
<?php
class Order {
    const STATUS_NEW = 'new';
    const STATUS_CHECKED_OUT = 'checked-out';

    private $items;
    private $status;
    private $statusAt;

    public function __construct() {
        $this->items = [];
        $this->status = self::STATUS_NEW;
        $this->statusAt = new \DateTime();
    }

    public function checkout() {
        $this->status = self::STATUS_CHECKED_OUT;
        $this->statusAt = new \DateTime();
    }

    public function getStatus() { return $this->status; }
    public function getItems() { return $this->items; }
    public function addItem() { /* Unimplemented yet */ }
}
{{< /highlight >}}

Voici à présent le code de notre sujet (la classe `CheckoutOrderHandler`) qui expose principalement une méthode métier `handle`.

{{< highlight php >}}
<?php
/**
 * The concrete subject
 */
class CheckoutOrderHandler implements Subject
{
    private $observers = [];

    public function addObserver(Observer $observer) {
        if (!in_array($observer, $this->observers)) {
            $this->observers[] = $observer;
        }
    }

    public function removeObserver(Observer $observer) { /* Unimplemented yet */ }

    public function handle(Order $order) {
        $order->checkout();
        $this->notifyObservers($order);
    }

    public function notifyObservers(Order $order) {
        foreach ($this->observers as $observer) {
            $observer->notify($order);
        }
    }
}
{{< /highlight >}}

Cette classe `CheckoutOrderHandler` :

* implémente bien entendu l'interface `Subject`,
* possède en propriété la liste de ses observateurs,
* invoque sa méthode `notifyObservers` lorsqu'elle modifie l'état de la commande (`$order->checkout()`).

### Les observateurs (`OrderConfirmationMailer` et `StockUpdater`)

{{< highlight php >}}
<?php
/**
 * A concrete observer. Service responsible for sending confirmation email to customer.
 */
class OrderConfirmationMailer implements Observer {
    public function notify(Order $order) {
        echo static::CLASS . " invoked. A confirmation mail will be sent to the customer.\n";
        // Not implemented yet
    }
}

/**
 * Another concrete observer. Service that is responsible for updating product stocks
 */
class StockUpdater implements Observer {
    public function notify(Order $order) {
        echo static::CLASS . " invoked. Stocks will be updated.\n";
        // Not implemented yet
    }
}
{{< /highlight >}}

### Utilisation

{{< highlight php >}}
<?php
    // Add one observer to our order handler:
    $order = new Order();
    $checkoutOrderHandler = new CheckoutOrderHandler();
    $orderConfirmationMailer = new OrderConfirmationMailer();
    $checkoutOrderHandler->addObserver($orderConfirmationMailer);
    // The `notify` method of the observer should be invoked:
    $checkoutOrderHandler->handle($order);

    // Add another observer:
    $stockUpdater = new StockUpdater();
    $checkoutOrderHandler->addObserver($stockUpdater);
    // The `notify` method of each observer should be invoked:
    $checkoutOrderHandler->handle($order);
{{< /highlight >}}

## Conclusion

Les développeurs Java qui ont eu l'occasion de se frotter à ses bibliothèques graphiques (AWT, Swing, JavaFX) auront sans doute remarqué que c'est le pattern `Observer` qui est implémenté pour ajouter des comportements aux composants graphiques :

{{< highlight java >}}
public class MyFrame extends JFrame implements ActionListener {

        public function init() {
            ...
            JButton myButton = new JButton("Cliquez ici !");
            myButton.addActionListener(this);
        }

        ...
        public void actionPerformed(ActionEvent e) {
            System.out.println("Vous avez cliqué ici.");
        }
{{< /highlight >}}

Ici, la méthode `addActionListener` correspond à la méthode `registerObserver` du diagramme des participants, ou bien encore à la méthode `addObserver` que nous avons implémentée dans notre exemple. Le sujet observé est l'objet `JButton` et `MyFrame` est l'observateur qui réagit au changement d'état du bouton au moyen de sa méthode `actionPerformed`.

Parmi les vertus du pattern `Observer`, le GoF mentionne un couplage faible (dans la mesure où le sujet et les observateurs sont distincts et ont leurs responsabilités propres) mais on peut toutefois déplorer la dépendance forte existant entre le sujet et ses observateurs (le sujet est conscient de ses observateurs).

Il existe un pattern qui va plus loin que l'`Observer` pour permettre de limiter cette dépendance. Il s'agit du pattern `Mediator` :

> Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.

Le framework Symfony propose un composant dédié pour réagir aux événements, bien connu des développeurs PHP : [l'`Event Dispatcher`](https://symfony.com/doc/current/components/event_dispatcher.html). Et vous ne serez sans doute pas surpris d'apprendre que ce composant s'appuie sur le pattern `Mediator` :

> The Symfony EventDispatcher component implements the Mediator pattern

Nous aurons sans doute l'occasion d'y revenir ...

<style>
    .aside-note {
        border-left: 5px solid #ffa600;
        padding: 20px;
        margin: 20px 0;
    }
</style>

---
type:           "post"
title:          "Les Design Patterns 'Observer' & 'Mediator'"
date:           "2017-10-26"
publishdate:    "2017-10-26"
draft:          false
slug:           "design-patterns-observer-mediator"
description:    "Dans le cadre de notre série consacrée aux Design Patterns, nous nous intéressons aujourd'hui aux patterns 'Observer' et 'Mediator'"

thumbnail:      "/images/posts/thumbnails/big-brother.png"
header_img:     "/images/posts/headers/big-brother.png"
tags:           ["Design Pattern", "Conception"]
categories:     ["Dev", "Design Pattern"]

author_username:    "xavierr"

---

Aujourd'hui, deux Design patterns qui ont en commun de nous faire réagir à des événements: `Observer` et `Mediator`.

<!--more-->

## Le design pattern `Observer` (_aka_ `Publisher/Subscriber`)

### Classification

Le pattern `Observer` appartient aux Design patterns dits "comportementaux" (`Behavior`)

### Définition (GoF)

> The observer pattern is a design pattern that defines a link between objects so that when one object's state changes, all dependent objects are updated automatically. This pattern allows communication between objects in a loosely coupled manner.

En résumé, le DP `Observer` est utile lorsque un ou plusieurs objets (les _observateurs_) doivent réagir au changement d'état d'un objet donné (le _sujet_).

### Diagramme des participants

<p class="text-center">
    {{< figure class="text-center" src="/images/posts/design-pattern/behavior-observer.png" alt="Le Design Pattern 'Observer'">}}
</p>

On distingue dans ce diagramme le sujet observé (`Subject`, ou bien encore `Publisher`) et ses observateurs (`Observer`, ou bien encore `Subscriber`).

### Exemple concret

Pour illustrer ce Design Pattern, nous partons du cas d'utilisation suivant, très fréquent dans les applications d'e-commerce : lorsqu'une commande est finalisée par un client, un mail de confirmation doit être envoyé au client et les stocks des produits commandés doivent être mis à jour.

Dans l'exemple qui suit,

* un service `CheckoutOrderHandler` est responsable de finaliser la commande : c'est le **Sujet observé**.

* plusieurs services réagissent à la finalisation d'une commande (`OrderConfirmationMailer`, `StockUpdater`, etc.) : ce sont les **observateurs**.

Commençons par introduire une classe métier modélisant très sommairement une commande (c'est cette classe métier que manipulera notre sujet `CheckoutOrderHandler`) :

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
    public function addItem() { /* */ }
}
{{< /highlight >}}

A présent, introduisons deux interfaces correspondant respectivement au sujet observé et aux observateurs (aucune surprise, les méthodes exposées par ces deux interfaces correspondent à celles qui figurent dans le diagramme des participants) : 

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

## Le design pattern `Mediator`

### Classification

Le pattern `Mediator` appartient aux Design patterns dits "comportementaux" (`Behavior`)

### Définition (GoF)

> Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.

### Diagramme des participants

<p class="text-center">
    {{< figure class="text-center" src="/images/posts/design-pattern/behavior-mediator.gif" alt="Le Design Pattern 'Mediator'">}}
</p>


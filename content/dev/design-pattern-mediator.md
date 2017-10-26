---
type:           "post"
title:          "Le Design Patterns 'Mediator'"
date:           "2017-10-26"
publishdate:    "2017-10-26"
draft:          false
slug:           "design-patterns-mediator"
description:    "Dans le cadre de notre série consacrée aux Design Patterns, nous nous intéressons aujourd'hui au DP 'Mediator'"

thumbnail:      "/images/posts/thumbnails/handshake.png"
header_img:     "/images/posts/headers/handshake.jpg"
tags:           ["Design Pattern", "Conception"]
categories:     ["Dev", "Design Pattern"]

author_username:    "xavierr"

---

Aujourd'hui, deux Design patterns qui ont en commun de nous faire réagir à des événements: `Observer` et `Mediator`.

<!--more-->

## Classification

Le pattern `Mediator` appartient aux Design patterns dits "comportementaux" (`Behavior`)

## Définition (GoF)

> Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.

### Diagramme des participants

<p class="text-center">
    {{< figure class="text-center" src="/images/posts/design-pattern/behavior-mediator.gif" alt="Le Design Pattern 'Mediator'">}}
</p>


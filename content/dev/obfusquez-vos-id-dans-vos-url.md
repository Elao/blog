---
type:               "post"
title:              "Obfusquez vos id dans vos url"
date:               "2019-09-25"
publishdate:        "2019-09-25"
draft:              false
slug:               "obfusquez-vos-id-dans-vos-url"
description:        "Découverte d'alternatives aux ID auto-incrémentés dans les urls et leur mise en place dans le framework Symfony."

thumbnail:          "/images/posts/thumbnails/vuejs.jpg"
header_img:         "/images/posts/headers/vuejs.jpg"
tags:               ["Securite","PHP","Symfony","Framework"]
categories:         ["Dev", "Symfony"]

author_username:    "mcolin"
---

L'une des pratiques les plus courantes du web pour accéder à un contenu de base de données est d'inclure l'identifiant (ID) de celui-ci dans l'url. Cet identifiant est dans la grande majorité des cas un entier positif auto-incrémenté par la base de données. Cet identifiant se retrouve ainsi exposé dans les urls. Bien qu'elle pose un certain nombre de problème, cette pratique est très simple et très répandu.

## Problèmes de sécurités et de confidentialité

Exposer ces identifiants dans les url pose principalement des problèmes de **sécurité** et de **confidentialité**.

La cause de ses problèmes est du à la prédictabilité de l'identifiant. En effet, celui-ci étant auto-incrémenté, si vous avez une url avec un identifiant, il est très facile de déduire les urls d'autres contenus en incrémentant ou décrémentant l'identifiant dans l'url.

Il est alors simple pour un hacker ou simplement un utilisateur curieux de tenter accéder à des contenus qui ne lui sont pas dédié. Couplé à d'autres failles ou défaut de sécurité, cela lui facilitera grandement la tâche. Il est également simple de crawler votre contenu sans connaitre à l'avance toutes les urls, mais simplement en bouclant sur un identifiant incrémenté.

Et enfin, il est également simple de connaitre vos volumes de données. Par exemple, si je m'inscris sur un site et que je vois dans une url que mon compte utilisateur à l'ID 100, je sais qu'il n'y a que 100 utilisateurs inscrit sur ce site, si je passe une commande et qu'elle a l'identifiant 30, je sais qu'il n'y a eu que 30 commandes et je peux ensuite déduire le nombre de commandes moyen par utilisateur. Autant d'informations sensibles, surtout si vous êtes en concurance.

## Les alternatives aux ID auto-incrémentés

Plusieurs alternatives aux identifiants auto-incrémentés existent.

L'une des plus connus est l'**[UUID](https://fr.wikipedia.org/wiki/Universal_Unique_Identifier)**. Cet identifiant de 32 caractères hexadécimaux est généré de façon unique par un algorithme. A partir d'un UUID d'un contenu il n'est pas possible de prédire celui des autres. Il est très utilisé lors d'échange API néanmoins il souffre d'un inconvéniant majeur pour des urls, sa longueur.

L'url suivante est quand même beaucoup moins lisible et pratique que la même utilisant des ID entier :

<figure>
  <pre>https://www.example.com/shop/category/b441a884-5d46-423b-8317-ddb6f7e3f2fb/product/f0283088-5bd3-4acc-bc42-e6d173d33dd8?filter=165779fc-171d-4f3c-8c60-a2351d6468d3</pre>
  <figcaption>Une url avec des UUIDs</figcaption>
</figure>

<figure>
  <pre>https://www.example.com/shop/category/3/product/56?filter=33</pre>
  <figcaption>Une url avec des ID</figcaption>
</figure>

Une autre solution pourrait être d'utilser des **identifiants entier non auto-incrémenté**. Cela nécessite néanmoins la mise en place d'un algorithme permettant de générer de manière unique ces identifiants. C'est une solution qui peut être viable, mais pas forcement simple à mettre en place et la perte d'auto-increment côté base de données peut être handicapant.

## L'obsuscation

Afin de concerver mes identifiants auto-incrementé en interne mais de ne pas les exposés j'ai opté pour l'obfuscation. Le principe est simple, mes IDs sont encoder avant d'être inséré dans les urls puis décoder à chaque requête de façon a ce que l'utilisateur ne voit jamais les vrais IDs.

En PHP il existe plusieurs bibliothèques permetant d'obfusquer un ID numérique, encodant un entier en une chaines héxadécidémales, une chaines base64 ou un autre entier par example.

* [zackkitzmiller/tiny](https://github.com/zackkitzmiller/tiny-php)
* [marekweb/opaque-id](https://github.com/marekweb/opaque-id)
* [jenssegers/optimus](https://github.com/jenssegers/optimus)

J'ai utilisé [**optimus**](https://github.com/jenssegers/optimus) qui transforme votre ID en un autre entier.

{{< highlight php >}}
<?php
$optimus = new Optimus(1580030173, 59260789, 1163945558);
$encoded = $optimus->encode(20); // 1535832388
$original = $optimus->decode(1535832388); // 20
{{< /highlight >}}


<style type="text/css">
figure figcaption {
  text-align: center;
  font-style: italic;
  font-size: 80%;
}

figure pre {
  margin: 0;
}

figure {
  margin: 20px 0;
}
</style>

## Intrégation dans Symfony

Afin de ne pas avoir à encoder moi même les ID, j'ai créé un decorator pour le router Symfony.

Voici un exemple simple qui obfusque tous les paramêtres `id` des routes.

{{< highlight php >}}
<?php
class IdObfuscatorUrlGenerator implements RouterInterface
{
    private $inner;
    private $idObfuscator;

    public function __construct(RouterInterface $inner, IdObfuscatorInterface $idObfuscator)
    {
        $this->inner = $inner;
        $this->idObfuscator = $idObfuscator;
    }

    public function generate($name, $parameters = [], $referenceType = self::ABSOLUTE_PATH)
    {
        foreach ($parameters as $key => $value) {
            if ($key === 'id') {
                $parameters[$key] = $this->idObfuscator->obfuscate($value);
            }
        }

        return $this->inner->setContext($name, $parameters, $referenceType);
    }

    public function setContext(RequestContext $context)
    {
        return $this->inner->setContext($context);
    }

    public function getContext()
    {
        return $this->inner->getContext();
    }

    public function getRouteCollection()
    {
        return $this->inner->getRouteCollection();
    }

    public function match($pathinfo)
    {
        return $this->inner->match($pathinfo);
    }
}
{{< /highlight >}}

Il faut ensuite déobfusquer les ID a chaque requête avant de pouvoir les utiliser. J'utilise pour celà un `ArgumentValueResolver`.

Par exemple, voici celui qui correspondrait au routeur si dessus :

{{< highlight php >}}
<?php
class ObfuscatedIdResolver implements ArgumentValueResolverInterface
{
    /** @var IdObfuscatorInterface */
    private $idObfuscator;

    public function __construct(IdObfuscatorInterface $idObfuscator)
    {
        $this->idObfuscator = $idObfuscator;
    }

    public function supports(Request $request, ArgumentMetadata $argument)
    {
        return $argument->getType() === 'int' && $request->attributes->has('id');
    }

    public function resolve(Request $request, ArgumentMetadata $argument)
    {
        yield $this->idObfuscator->deobfuscate($request->attributes->getInt('id'));
    }
}
{{< /highlight >}}

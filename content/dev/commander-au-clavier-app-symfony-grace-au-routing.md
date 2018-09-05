---
type:           "post"
title:          "Commander au clavier une application Symfony grâce au Routing"
date:           "2018-09-01"
publishdate:    "2018-09-01"
draft:          false
slug:           "commander-au-clavier-app-symfony-grace-au-routing"
description:    "Comment ajouter à une application Symfony une UI différente, une interface de commande par texte avec autocompletion."
summary:        true

thumbnail:      "/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/demo-avec-parametre.png"
header_img:     "/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/demo-avec-parametre.png"
tags:           ["Symfony", "Routing", "UX"]
categories:     ["dev", "Symfony"]

author_username: "rhanna"

---

Lorsqu'une application comporte des centaines de fonctionnalités et des millions de lignes en base de données,
il est souvent fastidieux d'accéder à une information.
Il faut choisir le bon élément dans un menu, chercher dans une liste, cliquer sur modifier, accéder à un formulaire
pour enfin pouvoir modifier une donnée.

Nous allons voir comment on peut ajouter à une application Symfony une UI différente,
une interface de commande par texte avec autocompletion.

## Le contexte

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/backoffice.png" alt="Backoffice" />
</p>

Ceci est une capture d'écran d'interface d'administration d'une application classique.
Il y a des listes, des boutons, des menus...
Pour accéder à une ressource ou à une fonctionnalité, plusieurs clics sont nécessaires.

Et si on avait une UI différente ?

Dans notre temps dédié aux *side projects*, nous avons eu l'idée de voir ce qu'on pouvait faire pour accéder
plus rapidement et plus efficacement aux ressources d'une application. L'idée est de s'inspirer des suggestions de
résultats comme sur Google, Spotlight ou Alfred sous Mac.

Exemple lorsqu'on tape "Modifier document" sur Google :

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/search.png" alt="Recherche avec suggestion de résultats" />
</p>

Cela serait pas mal d'avoir la même chose dans notre application, n'est-ce pas ?

## Exploiter le *routing* de Symfony ?

Symfony dispose des commandes *Console* mais cette interface est dédiée aux développeurs.
L'idée est d'avoir un moteur de recherche dans le navigateur qui suggère des résultats qui irait piocher dans notre
application sans forcément écrire complètement une API côté Backend. Et pourquoi pas exploiter le *Routing* de Symfony ? 
Nous allons voir pas à pas comment nous avons exploité le *routing* pour répondre à notre besoin.

### Récupérer toutes les routes de l'application

{{< highlight php >}}
<?php

use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouterInterface;

class AllRoutesResolver
{
    /** @var RouterInterface */
    private $router;

    public function __construct(RouterInterface $router)
    {
        $this->router = $router;
    }

    /**
     * @return Route[]
     */
    public function getAllRoutes(): array
    {
        return $this->router->getRouteCollection()->all();
    }
}
{{< /highlight >}}

Cela donne comme résultat en faisant un *dump* :

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/all-routes-dump.png" alt="Dump de routes les routes de l'application" style="width: 50%" />
</p>

Filtrons maintenant les routes en ne gardant que les routes avec méthode GET :

{{< highlight php >}}
<?php
    // ...
    return array_filter(
        $this->router->getRouteCollection()->all(),
        function (Route $route) {
            return \in_array('GET', $route->getMethods(), true);
        }
    );
{{< /highlight >}}

### Humaniser les noms de route

Maintenant qu'on a toutes les *routes* de l'application, il faut pouvoir les proposer à l'utilisateur.
L'idée est de transformer le nom de chaque *route* en libellé "humanisé" :

- admin_user_list ➡ User list
- admin_user_create ➡ User create
- admin_generate_invoice_for_order ➡ Generate invoice for Order

Pour obtenir ce résultat, on a simplement supprimé le préfixe `admin_` et les `_`, puis mis la première lettre en
majuscule.

### Générer l'url

Pour générer l'url à partir d'une route, rien de plus trivial :

{{< highlight php >}}
<?php
    /** @var RouterInterface $router */
    return $router->generate($routeName, $parameters);
{{< /highlight >}}

On créé des vues contenant le libellé et l'url et cela donne quelque chose comme ça :

```
array:140 [▼
  0 => ResultView {#1388 ▼
    +label: "User list"
    +routeName: "admin_user_list"
    +url: "/user/list"
```

### Démo

Pour le widget côté navigateur permettant à l'utilisateur de faire sa recherche et d'avoir des suggestions de résultats,
nous avons choisi une librairie assez légère et facilement configurable, notamment au niveau de la source de données :
[Pixabay/JavaScript-autoComplete](https://github.com/Pixabay/JavaScript-autoComplete).

Et cela donne comme résultat :

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/demo.png" alt="Démo" />
</p>

## Deviner des paramètres de route

Que faire maintenant si nos routes attendent des paramètres ? En terme d'expérience utilisateur, on souhaite que
l'application nous suggère des résultats. Par exemple, si on tape "User update", l'application nous propose l'ensemble
des utilisateur pouvant être modifiés :

```
➡ User update Korben DALLAS
➡ User update Leeloo Ekbat De Sebat
➡ User update Cornelius
```

### Récupérer les requirements d'une route

Considérons que l'on a cette *route* :

{{< highlight yaml >}}
# Routing
admin_user_update:
    path: /user/update/{user}
    methods: [GET, POST]
    requirements:
        user: \d+
    defaults: { _controller: AdminBundle:User:update }
{{< /highlight >}}

Notre *requirement* apparaît être un paramètre `user` qui est de type numérique.

Dans notre *controller*, le paramètre `user` va être transformé grâce au `ParamConverter` de Symfony en objet
de la classe `User` :

{{< highlight php >}}
<?php

class UserController extends Controller
{
    public function updateAction(Request $request, User $user): Response
    {
{{< /highlight >}}

Ou ici avec un *invokable controller* (*Action Domain Response pattern*) :

{{< highlight php >}}
<?php

class UpdateUserAction
{
    public function __invoke(Request $request, User $user): Response
    {
{{< /highlight >}}

Par le code, récupérer les *requirements* d'une *route* :

{{< highlight php >}}
<?php

public function getRequirements(Route $route): array
{
    return array_keys($route->getRequirements());
}
{{< /highlight >}}

On sait ainsi par le code que la route `admin_user_update` a pour *requirement*, un paramètre `user`.

### Récupérer les metadata du controller d'une route

{{< highlight php >}}
<?php

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Controller\ControllerResolverInterface;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadata;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadataFactoryInterface;
use Symfony\Component\Routing\Route;

class RouteArgumentsMetadata
{
    /** ... */

    public function __construct(
        ControllerResolverInterface $controllerResolver,
        ArgumentMetadataFactoryInterface $argumentMetadataFactory
    ) {
        $this->controllerResolver = $controllerResolver;
        $this->argumentMetadataFactory = $argumentMetadataFactory;
    }

    /** @return ArgumentMetadata[] */
    public function getArgumentsMetadata(Route $route): array
    {
        $request = new Request([], [], ['_controller' => $route->getDefault('_controller')]);
        $controller = $this->controllerResolver->getController($request);

        return $this->argumentMetadataFactory->createArgumentMetadata($controller);
    }
}
{{< /highlight >}}

Résultat :

```
array:2 [▼
  0 => ArgumentMetadata {#2146 ▼
    -name: "request"
    -type: "Symfony\Component\HttpFoundation\Request"
    -isVariadic: false
    -hasDefaultValue: false
    -defaultValue: null
    -isNullable: false
  }
  1 => ArgumentMetadata {#2151 ▼
    -name: "user"
    -type: "App\Domain\Model\User"
    -isVariadic: false
    -hasDefaultValue: false
    -defaultValue: null
    -isNullable: false
  }
]
```

On a donc une variable `user` dont le type est `App\Domain\Model\User`.
Cela devient carrément intéressant !
Continuons...

### Custom resolver

Nous allons coder un *Resolver* dédié pour un paramètre dès lors qu'il est de type `App\Domain\Model\User`.

Ici on sait que notre classe `User` est une classe mappé avec Doctrine. Nous allons faire appel à un *repository
Doctrine* pour récupèrer une liste des utilisateurs depuis la base de données. On prend soin de retourner le résultat
en précisant que la valeur du paramètre `user` prend pour valeur l'id de l'utilisateur :

{{< highlight php >}}
<?php

class UserResolver implements ResolverInterface
{
    /** ... */

    /** ResultView[] */
    public function resolve(ResultView $parentResultView): array
    {
        $enabledUsers = $this->userRepository->getEnabledUser();
        $resultViews = [];

        foreach ($enabledUsers as $user) {
            $resultViews[] = new ResultView(
                $parentResultView->label . ' ' . $user->getFullName(),
                $parentResultView->routeName,
                $router->generate($parentResultView->routeName, ['user' => $user->getId()]),
                ['user' => $user->getId()]
            );
        }

        return $resultViews;
    }
}
{{< /highlight >}}

On obtient ce résultat :

```
array:2 [▼
  0 => ResultView {#1395 ▼
    +label: "User update Korben DALLAS"
    +routeName: "admin_user_update"
    +url: "/user/update/42"
    +parameters: array:2 [▼
      "user" => 42
      "_locale" => "en"
    ]
  }
  1 => ResultView {#1403 ▼
    +label: "User update Leeloo Ekbat De Sebat"
    +routeName: "admin_user_update"
    +url: "/user/update/1337"
    +parameters: array:2 [▶]
  }
```

## Améliorations

### Resolver Doctrine ?

{{< highlight php >}}
<?php

use Doctrine\Common\Persistence\ManagerRegistry;

class DoctrineResolver {
    public function __construct(ManagerRegistry $managerRegistry) {
        $this->managerRegistry = $managerRegistry;
    }

    public function resolve(ResultView $resultView, string $paramName, string $className): array {
        $entityManager = $this->managerRegistry->getManagerForClass($className);
        if (null === $entityManager) { return []; }

        $objects = $entityManager->getRepository($className)->findAll();
        $resultViews = [];

        foreach ($objects as $object) {
            $parameters = $resultView->parameters;
            $parameters[$paramName] = $object->getId();

            $resultViews[] = new ResultView(
                sprintf('%s %s', $resultView->label, $object),
                $resultView->routeName,
                $resultView->url,
                $parameters
            );
        }

        return $resultViews;
    }
}
{{< /highlight >}}

Et ne pas oublier de déclarer une méthode __toString

{{< highlight php >}}
<?php

class User
{
    public function __toString(): string
    {
        return $this->getDisplayName();
    }
{{< /highlight >}}

### Traduction des noms de route

{{< highlight yaml >}}
# Routing
admin_user_list:
    path: /user/list/{user}

admin_user_create:
    path: /user/create/{user}

admin_user_update:
    path: /user/update/{user}
{{< /highlight >}}

{{< highlight yaml >}}
# humanized_routes.en.yml
admin_user_list: User List
admin_user_create: User Create
admin_user_update: User Update
{{< /highlight >}}

{{< highlight yaml >}}
# humanized_routes.fr.yml
admin_user_list: Utilisateur Lister
admin_user_create: Utilisateur Créer
admin_user_update: Utilisateur Modifier
{{< /highlight >}}

{{< highlight php >}}
<?php

use Symfony\Component\Translation\TranslatorBagInterface;
use Symfony\Component\Translation\TranslatorInterface;

class TranslateRouteName
{
    public function __construct(
        TranslatorInterface $translator,
        TranslatorBagInterface $translatorBag
    ) {
        $this->translator = $translator;
        $this->translatorBag = $translatorBag;
    }

    public function handle(string $routeName, string $locale): string
    {
        $catalogue = $this->translatorBag->getCatalogue($locale);
        
        return $catalogue->has($routeName, 'humanized_routes')
            ? $this->translator->trans($routeName, [], 'humanized_routes', $locale)
            : $this->humanizeRouteName($routeName);
    }

    protected function humanizeRouteName(string $routeName): string
    {
        return ucfirst(str_replace(['admin_', '_'], ['', ' '], $routeName));
    }
}
{{< /highlight >}}

{{< highlight yaml >}}
App\ActionsBot\Resolver\TranslateRouteName:
    arguments:
        - '@translator'
        - '@translator'
{{< /highlight >}}

### Démo

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/demo-avec-parametre.png" alt="Démo avec paramètre" />
</p>

## Bilan

### Résultat

- Nouvelle UX / UI basées sur les routes de l'application.
- Rapidité++ efficacité++.
- On pourrait imaginer avoir des commandes personnalisées : afficher le chiffre d'affaire du moisa, afficher le nombre
d'utilisateurs connectés...

### Inconvénients

- Il faut savoir quoi chercher.
- Savoir comment chercher. On pourrait résoudre ce problème en indiquant sur chaque page, comment y accéder par une
recherche texte.
- Inversion du langage : "Utilisateur Modifier" au lieu de "Modifier utilisateur". Pour améliorer, on pourrait proposer
une recherche en langage naturel.

## Commander par la voix ?

Depuis quelques mois, nos ordinateurs et enceintes connectées se sont dotés d'assistants vocaux plus ou moins
performants : Microsoft Cortana, Siri chez Apple, Amazon Alexa (Echo) ou Google Home.

Pourquoi ne pas piloter notre application web avec la voix ? Par exemple, en réunion on pourrait demander
"Quel est le Chiffre d'affaire du mois sur le produit TROPSTYLÉ ?" et avoir une réponse en synthèse vocale.

Web Speech API
Speech Synthesis
Speech Recognition
Synthèse vocale à partir d'un texte écrit
Reconnaissance automatique de la parole

{{< highlight js >}}
var recognition = new SpeechRecognition();
recognition.continuous = true;
recognition.lang = 'fr-FR';

recognition.onresult = function (event) {
  for (i = event.resultIndex; i < event.results.length; i++) {
    var result = event.results[i][0];
    console.log(result.transcript + ': ' + result.confidence);
  }
};

recognition.start();
{{< /highlight >}}

Démo ici : https://www.google.com/intl/en/chrome/demos/speech.html

Le support de l'API SpeechRecognition est très limité pour l'instant :

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/caniuse-speech-recognition.png" alt="Can I Use SpeechRecognition" />
</p>

Cependant, c'est une technologie assez promoteuse. A suivre donc !

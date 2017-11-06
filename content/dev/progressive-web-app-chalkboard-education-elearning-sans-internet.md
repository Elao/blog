---
type:           "post"
title:          "Du e-learning sans internet ou presque"
date:           "2017-11-27"
publishdate:    "2017-11-27"
draft:          false
slug:           "progressive-web-app-chalkboard-education-elearning-sans-internet"
description:    "Retour d'expérience sur la progressive web app Chalkboard Education"

thumbnail:      "/images/posts/2017/chalkboard-education/courses-list.png"
header_img:     "/images/posts/2017/chalkboard-education/courses-list.png"
tags:           ["progressive web app", "service worker", "web", "mobile", "offline", "React", "Symfony", "GraphQL"]
categories:     ["dev", "Symfony", "javascript"]

author_username: "rhanna"

---

## Le contexte

Dans certains pays africains, le nombre de places disponibles à l'université est très limité.
Par conséquent de nombreux étudiants n'ont pas accès à l'université.
La startup [Chalkboard Education](https://chalkboard.education/) implantée au Ghana et en Côte d'Ivoire a pour but de
résoudre ce problème en diffusant les cours d'universités via les téléphones mobiles.
Les étudiants africains n'ont certes pas forcément le dernier modèle de smartphone ni une connexion Internet fiable mais
cela est suffisant pour accéder à la connaissance.

## Application native

Elao accompagne Chalkboard Education depuis 2015 sur la conception de son produit.
Une première preuve de concept a été réalisée en [React Native](https://facebook.github.io/react-native/) avec pour
résultat une application Android déployée sur Google Play Store à destination de plusieurs centaines d'étudiants de
l'University Of Ghana.

## Progressive Web App

Avec l'émergence des [Progressive Web Apps](/fr/dev/la-revanche-du-web-par-les-progressive-web-apps/), nous avons
conseillé Chalkboard Education de revenir au web pour plusieurs raisons :

- Le public visé est majoritairement sur Android, OS pour lequel actuellement les navigateurs supportent le mieux le
Service Worker et le Web App Manifest, éléments clés du concept de Progressive Web App.
- La couverture des appareils ciblés est beaucoup plus large du fait qu'il s'agisse d'une application web.
- Le coût du développement est moins important que le développement d'applications natives pour Android et iOS.
- Le poids d'une web app est beaucoup moins important qu'une application native ce qui est un avantage pour des
populations ayant un accès limité à Internet.
- La fréquence de mise à jour est plus simple et ne dépend pas de la bonne volonté des stores d'applications.

En quoi Chalkboard Education est une Progressive Web App ?
- Le *front* déclare dun [manifeste d'une application web](https://developer.mozilla.org/fr/docs/Web/Manifest) permettant
d'installer Chalkboard Education sur l'écran d'accueil du smartphone ou tablette.
- Utilisation hors-ligne de l'application : tous les contenus pré-chargés et mis en cache permettant la consulation des
cours par les étudiants sans Internet.

## Front office avec React et Redux ♥️

[Create React App](https://github.com/facebookincubator/create-react-app)
Web app front en SPA avec React, Redux, Redux-persist et Webpack

### Démo

<div style="text-align:center; background: #333; padding: 20px">
<video src="/images/posts/2017/chalkboard-education/demo.mp4" controls autoplay></video>
</div>

### UI/UX inspirées des applications natives

Material UI

Eviter les formulaires.
Centrer à l'écran les actions à faire par l'utilisateur.

<p class="text-center">
    <img src="/images/posts/2017/chalkboard-education/submit-progression.png" alt="Submit progression" style="max-width:80%"/>
</p>

Ecran simple avec une seule action à faire:
- choisir un cours dans une liste,
- lire un cours et passer à la suite
- valider sa progression en choisissant parmi SMS ou Internet.

### API GraphQL ♥️

Nous avons choisi d'implémenter une API GraphQL au lieu de REST :
- pour réduire le nombre de requêtes HTTP,
- laisser le front choisir les contenus qu'il souhaite utiliser,
- parce que GraphQL c'est quand même bien cool.

Par exemple dans la requête suivante le *front* demande à la fois :
- un *currentDate* (une date serveur),
- la liste des *courses* (ses *folders*, les *sessions* des *folders*, les *files* des *sessions*),
- et le *user* courant. 

{{< highlight js >}}
// src/graphql/query/CoursesQuery.js
import gql from 'graphql-tag';

export default gql`
  {
    currentDate
    user {
      uuid
      firstName
      lastName
      country
      phoneNumber
      locale
    }
    courses {
      uuid
      title
      updatedAt
      folders {
        uuid
        title
        updatedAt
        sessions {
          uuid
          title
          updatedAt
          files {
            url
            updatedAt
          }
        }
      }
    }
  }
`;
{{< /highlight >}}

### Mobile-first et Offline-first

Check mise à jour toutes les 24h si l'utilisateur a une connexion.
Nombre de Ko à télécharger pour chaque mise à jour.
Les contenus sont stockés de différentes manières:
le contenu du cours est dans le store Redux et persisté en localStorage
les médias (images) du cours sont stockés en cache storage Service Worker
Auth User
HasUpdates
Get Courses
Fetch session content
Fetch images URL

[Redux Persist](https://github.com/rt2zz/redux-persist) permet de persister le *store Redux* en
[LocalStorage](https://developer.mozilla.org/fr/docs/Web/API/Storage/LocalStorage) et de réhydrater le *store* dès lors
que la page web est rechargée.

{{< highlight js >}}
// store.js
import ApolloClient, { createNetworkInterface } from 'apollo-client';
import { applyMiddleware, compose, createStore } from 'redux';
import { autoRehydrate } from 'redux-persist';

import appReducer from '../reducers';
import defaultState from './defaultState';

const store = createStore(
  appReducer,
  defaultState,
  compose(
    applyMiddleware(whateverMiddleware),
    autoRehydrate() // redux persist auto rehydrate the store
  )
);

const networkInterface = createNetworkInterface({
  uri: 'https://api.chalkboard.education'
});

const GraphqlClient = new ApolloClient({ networkInterface });

networkInterface.use([
  {
    applyMiddleware(req, next) {
      // Create the header object if needed
      if (!req.options.headers) {
        req.options.headers = {};
      }

      const userToken = store.getState().currentUser.token;
      
      req.options.headers.authorization = userToken
        ? `Bearer ${userToken}`
        : null;
      
      next();
    }
  }
]);
{{< /highlight >}}

### Service worker

[Create React App](https://github.com/facebookincubator/create-react-app) permet facilement de *bootstraper* un front
avec React et un service worker qui pré charge en cache les assets de l'application (index.html, javascript et css).

Pour mettre en cache les urls chargées au *runtime* il faut surcharger la configuration du *builder* du Service Worker
avec [sw-precache](https://github.com/GoogleChromeLabs/sw-precache). On a rajouté une commande "generate-sw" dans notre
fichier package.json :

{{< highlight json >}}
{
  "name": "ChalkboardEducationV2ReactFront",
  "private": true,
  "dependencies": {
    ...
  },
  "devDependencies": {
    ...,
    "sw-precache": "^5.2.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build && yarn run generate-sw",
    "generate-sw": "sw-precache --root='build/' --config config/sw-precache-config.js",
    "test": "react-scripts test --env=jsdom"
  }
}
{{< /highlight >}}

Configuration pour *sw-precache* pour gérer le *runtime caching* des images :

{{< highlight js >}}
// config/sw-precache-config.js
module.exports = {
  staticFileGlobs: [
    'build/**/*.js',
    'build/**/*.css',
    'build/index.html'
  ],
  runtimeCaching: [{
    urlPattern: /\.*\.(?:svg|jpg|gif|png)/g,
    handler: 'cacheFirst'
  }]
};
{{< /highlight >}}

### Le SMS pour transporter de la donnée sans Internet

Login via token unique par user envoyé par sms. Peu email. Identifiant téléphone
Validation progression par sms
Validation d'une session par internet ou par SMS. L'app front génère un code, envoyée par SMS.
Sms lu par le back.
Code décodé pour identifier l'utilisateur et la session validée

## Back office et API avec Symfony ♥️

Chalkboard Education a besoin d'un back-office d'administration permettant de :
- gérer les étudiants (créer, importer),
- saisir les contenus des cours,
- assigner des cours aux étudiants,
- envoyer un SMS contenant l'url d'accèsà un étudiant,
- voir la progression des étudiants pour chaque cours.

Etant donné que l'on connait bien Symfony, c'était la solution idéale pour rapidement *bootstraper* le back office
d'administration et l'API permettant d'accéder aux informations par le *front*.

Toutes nos classes métiers et tous les controllers Symfony sont testés unitairement par Phpunit.
Des scénarios Behat permettent de couvrir également la quasi totalité des fonctionnalités du Back-Office.

### Back office

Pour tous nos *controllers*, nous nous sommes inspirés du *pattern Action-Domain-Response (ADR)* avec les
[Invokable Controllers](http://symfony.com/doc/current/controller/service.html#invokable-controllers).
Cela a beaucoup d'avantages :
- Une classe *controller* = une action
- Peu de ligne de code dans un *controller* : *Keep It Simple Stupid*
- Cela pousse à découpler le code, et toute logique hors controller est codée dans des services du domaine
- Une classe de *controller* est ainsi facilement testable unitairement

Exemple de "nouveau" *controller* :

{{< highlight php >}}
<?php

namespace App\Ui\Admin\Action\Course;

use App\Application\Adapter\CommandBusInterface;
use App\Application\Command\Course\AssignUser;
use App\Domain\Model\Course;
use App\Ui\Admin\Form\Type\Course\AssignUserType;
use Symfony\Bundle\FrameworkBundle\Templating\EngineInterface;
use Symfony\Component\Form\FormFactoryInterface;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Session\Flash\FlashBagInterface;
use Symfony\Component\Routing\RouterInterface;

class AssignUserAction
{
    /** @var EngineInterface */
    private $engine;

    /** @var CommandBusInterface */
    private $commandBus;

    /** @var FormFactoryInterface */
    private $formFactory;

    /** @var RouterInterface */
    private $router;

    /** @var FlashBagInterface */
    private $flashBag;

    public function __construct(
        EngineInterface $engine,
        CommandBusInterface $commandBus,
        FormFactoryInterface $formFactory,
        RouterInterface $router,
        FlashBagInterface $flashBag
    ) {
        $this->engine = $engine;
        $this->commandBus = $commandBus;
        $this->formFactory = $formFactory;
        $this->router = $router;
        $this->flashBag = $flashBag;
    }

    public function __invoke(Request $request, Course $course): Response
    {
        $assign = new AssignUser($course);
        $form = $this->formFactory->create(AssignUserType::class, $assign, []);

        if ($form->handleRequest($request)->isSubmitted() && $form->isValid()) {
            $this->commandBus->handle($assign);
            $this->flashBag->add('success', 'flash.admin.course.assign_user.success');

            return new RedirectResponse($this->router->generate('admin_course_list'));
        }

        return $this->engine->renderResponse('Admin/Course/assign_users.html.twig', [
            'form' => $form->createView(),
            'course' => $course,
        ]);
    }
}
{{< /highlight >}}

Nous avons utilisé [l'autowiring des services](https://symfony.com/doc/current/service_container/autowiring.html)
qui rend beaucoup plus simple la gestion des dépendances: 

{{< highlight yaml >}}
services:
    _defaults:
        # automatically injects dependencies in services
        autowire: true
        # automatically registers your services as commands, event subscribers, etc.
        autoconfigure: true

    # example:
    App\Ui\Admin\Action\Course\AssignUserAction:
        autowire: true
{{< /highlight >}}

Et pour 

{{< highlight yaml >}}
    App\Ui\Admin\Action\User\ConfirmImportAction:
        autowire: true
        arguments:
            $importDir: '%infrastructure.user_import_dir%'
{{< /highlight >}}


### GraphQL et Symfony

https://github.com/overblog/GraphQLBundle
et https://github.com/webonyx/graphql-php

Schema

{{< highlight yaml >}}
Course:
    type: object
    config:
        description: "A course"
        fields:
            uuid:
                type: "String!"
                description: "The uuid of the course."
            title:
                type: "String!"
                description: "The title of the course."
            updatedAt:
                type: "DateTime!"
                description: "The last update date of the course in format 2017-01-15 10:00"
            folders:
                type: "[Folder]"
{{< /highlight >}}

Resolver

{{< highlight yaml >}}
services:
    App\Infrastructure\GraphQL\Resolver\CourseResolver:
        autowire: true
        tags:
            - { name: overblog_graphql.resolver, alias: "courses", method: "resolveCourses" }
{{< /highlight >}}

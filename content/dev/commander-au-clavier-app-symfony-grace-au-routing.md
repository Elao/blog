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

Nous allons voir comment on peut facilement ajouter à une application Symfony une UI différente,
une interface de commande par texte avec autocompletion.

## Le contexte

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/backoffice.png" alt="Backoffice" />
</p>

Interface d'administration d'une application classique.
Il y a des listes, des boutons, des menus...
Il y a des centaines de fonctionnalités et des millions de lignes en base de données.
Accéder à une ressource peut parfois être fastidieux : plusieurs clics pour accéder à une fonctionnalité.

Et si on disruptait l'UI de notre application ?
Dans nos 20% off dédié aux sides project, dojo de toute sorte, nous avons eu l'idée de voir ce qu'on pouvait fort pour rendre accessible plus rapidement et plus efficacement les centaines de fonctionnalités d'une application.

Google, Spotlight ou Alfred sous mac
Recherche avec Autocompletion

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/search.png" alt="Recherche avec suggestion de résultats" />
</p>

Si on créait un chat bot ?

## Exploiter le routing de Symfony ?

Nous allons voir pas à pas comment nous avons exploité le routing pour répondre à notre besoin.

### Récupérer toutes les routes de l'application

{{< highlight php >}}
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

Dump Toutes les routes de l'application :

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/all-routes-dump.png" alt="Dump de routes les routes de l'application" />
</p>

### Filtrer les routes en ne gardant que les routes avec méthode GET

{{< highlight php >}}
    return array_filter(
        $this->router->getRouteCollection()->all(),
        function (Route $route) {
            return \in_array('GET', $route->getMethods(), true);
        }
    );
{{< /highlight >}}

### Humaniser les noms de route

admin_user_list ➡ User list
admin_user_create ➡ User create
admin_generate_invoice_for_order ➡ Generate invoice for Order

### Générer l'url

{{< highlight php >}}
class RouteGenerator
{
    /** @var RouterInterface */
    private $router;

    public function __construct(RouterInterface $router)
    {
        $this->router = $router;
    }

    public function generateUrl(string $routeName, array $parameters): string
    {
        return $this->router->generate($routeName, $parameters);
    }
}
{{< /highlight >}}

L'ensemble des urls générées

Dump

### Démo

https://github.com/Pixabay/JavaScript-autoComplete

<p class="text-center">
    <img src="/images/posts/2018/commander-au-clavier-app-symfony-grace-au-routing/demo.png" alt="Démo" />
</p>

## Deviner des paramètres de route

Routes avec des paramètres

Suggestion de résultats

User update_
➡ User update Korben DALLAS
➡ User update Leeloo Ekbat De Sebat
➡ User update Cornelius

### Récupérer les requirements d'une route

{{< highlight yaml >}}
# Routing
admin_user_update:
    path: /user/update/{user}
    methods: [GET, POST]
    requirements:
        user: \d+
    defaults: { _controller: AdminBundle:User:update }
{{< /highlight >}}

{{< highlight php >}}
class UserController extends Controller
{
    public function updateAction(Request $request, User $user): Response
    {
{{< /highlight >}}

Ou invokable controller (Action Domain Response pattern) :

{{< highlight php >}}
class UpdateUserAction
{
    public function __invoke(Request $request, User $user): Response
    {
{{< /highlight >}}

Récupérer les requirements d'une route

{{< highlight php >}}
public function getRequirements(Route $route): array
{
    return array_keys($route->getRequirements());
}
{{< /highlight >}}

Résultat :

admin_user_update -> user

### Récupérer les metadata du controller d'une route

{{< highlight php >}}
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Controller\ControllerResolverInterface;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadata;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadataFactoryInterface;
use Symfony\Component\Routing\Route;

class RouteGetter
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

Dump des metadata du controller d'une route

### Custom resolver

Resolver dédié pour le User.
Appel un repository Doctrine classique. Récupèrer liste des utilisateurs.
Créer un label (ici le nom/prénom), et passer la valeur du paramètre user permettant de générer l'url de la route, ici l'id.

{{< highlight php >}}
class UserResolver implements ResolverInterface
{
    /** ... */

    /** ResultView[] */
    public function resolve(ResultView $resultView): array
    {
        $enabledUsers = $this->userRepository->getEnabledUser();
        $resultViews = [];

        foreach ($enabledUsers as $user) {
            $resultViews[] = new ResultView($user->getFullName(), ['user' => $user->getId()]);
        }

        return $resultViews;
    }
}
{{< /highlight >}}

Dump du résultat

## Resolver Doctrine ?

{{< highlight php >}}
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
class User
{
    public function __toString(): string
    {
        return $this->getDisplayName();
    }
{{< /highlight >}}

## Traduction des noms de route

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

- Nouvelle UX / UI basées sur les routes
- Rapidité++ efficacité++
- Commandes auto-générées ou personnalisées : Chiffre d'affaire du mois / CA de l'année...
- Générer une API à partir du routing ?

Inconvénients
- inversion langage : "Utilisateur Modifier" au lieu de "Modifier utilisateur"
- proposer une recherche en langage naturel
- savoir quoi chercher
- savoir comment chercher -> indiquer sur chaque page via la route, comment y accéder par une recherche texte

## Commander par la voix ?

Alexa ? Google Home ?
On est en réunion et on demande "Quel est le CA du mois sur le produit BIDULE ?"

Assistants vocaux Cortana, Siri, Ok Google
enceintes connectés comme Alexa Echo ou Google Home

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

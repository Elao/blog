---
type:               "post"
title:              "Utiliser une IP statique et un loadbalancer «Ingress» avec Kubernetes"
date:               "2018-05-16"
publishdate:        "2018-05-16"
draft:              false
summary:            true
slug:               "kubernetes-ip-statique-ingress-loadbalancer"
description:        "Affecter une IP statique dédiée à un Ingress Kubernetes et répartir la charge."

thumbnail:          "/images/posts/thumbnails/kubernetes.png"
header_img:         "/images/posts/headers/to_the_moon.png"
tags:               ["kubernetes","k8s","infra","docker", "ingress"]
categories:         ["Infra", "Kubernetes"]

author_username:    "gfaivre"
---

Bonjour à tou(te)s !

Au menu aujourdhui, comment créer une IP publique statique avec Google Cloud et l'affecter à un **«Ingress»**

N.B.: J'ai choisi de ne pas traduire le terme n'ayant pas trouvé d'équivalent français satisfaisant et «point d'entrée» me paraissant avoir moins de sens.
<!--more-->

<span class="side-note light">🚧</span>Cet article suppose que vous disposez d'un cluster [Kubernetes](https://kubernetes.io/) fonctionnel sur Google Cloud Platform et que vous avez déjà créé un projet (au sens GCP) si ça n'est pas le cas rendez-vous [ici](https://console.cloud.google.com/projectselector/kubernetes)

---
## Avant propos

### Lexique

- **Ingress**: «Point d'entrée» dédié permettant de centraliser l'accès à divers services.
- **GCP**: [Google Cloud Platform](https://cloud.google.com)
- **Service**: Au sens Kubernetes c'est une couche d'abstraction qui permet d'exposer un (ou un groupe de) «**Pods**».

### Objectifs

- Réserver une IP statique
- Configurer un **«Ingress»** et un **«Service»** pour qu'ils utilisent cette IP et qu'ils utilisent 2 instances pour servir le client.

### Pré-requis GCP

- Vous avez déjà créé un projet
- Vous avez activé les fonctionnalités de facturation (Une adresse IP statique non utilisée est facturée)

### Pré-requis client

* [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts)
* kubctl - À installer avec la commande `gcloud components install kubectl`

## Création d'une IP statique

Avant de réserver notre IP, assurez-vous que la configuration projet est correcte, j'entends par là que vous êtes bien en train de travailler sur le bon projet. Il n'est, à ma connaissance, pas possible de basculer une IP d'un projet à un autre.

## Définir le projet par défaut qui va être utilisé

<span class="side-note light">📌</span>Si vous souhaitez savoir quelles sont les variables déjà configurées sur votre poste un `gcloud config list` devrait faire l'affaire.

Pour consulter une clé particulière (par exemple le projet configuré) nous utiliserons le flag `get-value`.

`gcloud config get-value project` renverra la valeur de la variable «project».

**Modifions notre projet:**

{{< highlight shell >}}
gcloud config set project cramaillote
{{< /highlight >}}

Vous pouvez également si vous souhaitez affecter votre IP à une zone géographique précise, spécifier la zone à la config (histoire d'éviter d'avoir à la saisir à chaque ligne de commande.)

{{< highlight shell >}}
gcloud config set compute/zone europe-west1
{{< /highlight >}}

## Création de l'adresse

<span class="side-note light">🚧</span>**Attention subtilité !**
Si vous passez le flag `--global` votre IP ne sera pas affectée à une zone géographique, si vous souhaitez avoir une IP localisée il faut spécifier la zone à laquelle elle sera rattachée:

{{< highlight shell >}}
gcloud compute addresses create cramaillote-endpoint --global
{{< /highlight >}}

{{< highlight shell >}}
gcloud compute addresses create cramaillote-endpoint --region=europe-west1 --description="Cramaillote project"
{{< /highlight >}}

<span class="side-note light">📌</span>**NB:** Par défaut c'est une adresse de type IPv4 qui est créée, c'est modifiable avec le flag `--ip-version=IPV6`

### Récupérer les informations de l'adresse nouvellement créée

Pour vérifier la bonne configuration de notre IP `gcloud compute addresses describe cramaillote-endpoint --region=europe-west1`

**Sortie:**

{{< highlight shell >}}
address: 35.195.235.95
creationTimestamp: '2018-01-26T01:11:12.026-08:00'
description: Cramaillote project
id: '4130839791640464991'
kind: compute#address
name: cramaillote-endpoint
region: https://www.googleapis.com/compute/v1/projects/elao-sandbox/regions/europe-west1
selfLink: https://www.googleapis.com/compute/v1/projects/elao-sandbox/regions/europe-west1/addresses/cramaillote-endpoint
status: RESERVED
{{< /highlight >}}


Première étape terminée !
Il ne nous reste plus qu'à utiliser cette IP afin de pouvoir exposer notre application, nous allons donc créer:

* Un **«Service»** de type `NodePort`
* Un **«Ingress»** avec notre IP publique et qui aura pour «backends» notre **«Pod»** Nginx (constitué donc, de 2 instances).

L'objectif final étant d'avoir un **Ingress** avec une IP publique statique qui fait office de répartiteur de charge vers 2 «backends» Nginx.

## Création des instances Nginx

Nous créons rapidement les instances applicatives qui seront chargées de nous répondre.

Pour cet exemple je suis parti sur une image faisant tourner un nginx qui doit me retourner le nom de l'instance sur laquelle il fonctionne.

{{< highlight nginx >}}
server {
    listen 8080 default_server;
    server_name _;

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    location / {
        return 200 "Hostname: $HOSTNAME";
    }
}
{{< /highlight >}}


On déploie nos instances avec le manifeste suivant:

{{< highlight yaml >}}
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: cramaillote-app-deployment
  labels:
    app: cramaillote-app
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: cramaillote-app
    spec:
      containers:
      - name: cramaillote-app
        image: "eu.gcr.io/elao-sandbox/cramaillote-nginx:latest"
        command: ["/bin/bash"]
        args: ["-c", "/usr/sbin/nginx"]
        ports:
          - containerPort: 8080
        imagePullPolicy: Always
{{< /highlight >}}

## Création de l'«Ingress»

Avec le manifeste suivant nous créons donc un **«Ingress»** qui va venir consommer notre IP publique et assurer le routage vers le **«Service»** `cramaillote-app`

{{< highlight yaml >}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: cramaillote-ingress
  annotations:
    kubernetes.io/ingress.global-static-ip-name: cramaillote-endpoint
spec:
  backend:
    serviceName: cramaillote-app-service
    servicePort: 8080
{{< /highlight >}}


Application du manifest `kubectl apply -f cramaillote-ingress.yml`

Une fois ce point d'entrée créé il devrait vous répondre sa page par défaut:

{{< highlight shell >}}
curl http://35.195.235.95
default backend - 404
{{< /highlight >}}

On notera l'affectation de notre IP statique grâce à l'annotation `kubernetes.io/ingress.global-static-ip-name`.
Si rien n'est spécifié, l'**«Ingress»** se verra affecter une adresse IP temporaire (qui changera donc à chaque fois qu'il sera détruit / recréé).

<span class="side-note light">💡</span>**Astuce**: Si vous avez déjà créé votre **«Ingress»** et souhaitez conserver votre IP, il est possible de promouvoir une IP temporaire en statique avec le flag `--addresses` de la manière suivante:

```
gcloud compute addresses create ADDRESS-1 ADDRESS-2 --addresses 162.222.181.197,162.222.181.198 --region europe-west1
``

On notera également la possibilité de fournir plusieurs adresses sur la même instruction.

## Création du «Service»

Pour terminer nous mettons en place le dernier «maillon» qui va venir se positionner entre notre **«Ingress»** et nos instances.

{{< highlight yaml >}}
apiVersion: v1
kind: Service
metadata:
  name: cramaillote-app-service
  labels:
    app: cramaillote-app
spec:
  type: NodePort
  selector:
    app: cramaillote-app
  ports:
  - name:       nginx
    protocol:   TCP
    port:       8080
    targetPort: 8080
{{< /highlight >}}

Que l'on applique: `kubectl apply -f cramaillote-service.yml`

<span class="side-note light">💡</span>**Astuce**: La création de l'ensemble des éléments constituant notre infrastructure est un peu fastidieuse, celle-ci est gérable de manière globale avec des outils de déploiement spécifiques à Kubernetes comme [Helm](https://helm.sh/)

## Conclusion:

Même s'il est possible d'exposer directement un **«Service»** en le définissant comme répartiteur de charge, l'**«Ingress»** nous permet d'ajouter de la logique de routage en frontal de nos applications.
Il est en effet possible, de «router» les requêtes arrivant sur l'**«Ingress»** vers des «backends» différents à partir de règles que l'on a défini.
Chose intéressante, un même **«Ingress»**, sur ce même principe de règles de routage, peut être utilisé pour répondre à plusieurs noms de domaine différents.

Pour terminer, nous utilisons un service HTTP pour notre exemple mais il est bien évident que les **«Ingress»** peuvent être configurés pour répondre à n'importe quel type de service.

---
type:               "post"
title:              "Provisionner simplement une stack de monitoring Telegraf + InfluxDB + Grafana avec Manala"
date:               "2016-11-16"
publishdate:        "2016-11-16"
draft:              false
slug:               "provisonner-simplement-stack-monitoring-telegraf-influxdb-grafana-avec-manala"
description:        "Comment utiliser les roles Ansible de Manala pour provisionner simplement une stack de monitoring Telegraf + InfluxDB + Grafana"

language:           "fr"
thumbnail:          "/images/posts/thumbnails/grafana.jpg"
header_img:         "/images/posts/headers/grafana.jpg"
tags:               ["provisoning","manala","ansible","influxdb","grafana","telegraf","monitoring"]
categories:         ["Infra", "manala", "ansible"]

author_username:    "mcolin"
---

## Manala

[Manala](http://www.manala.io/) est la boîte à outils pour [Ansible](https://www.ansible.com/) créer par [Elao](https://www.elao.com/fr/). Elle se compose d'une multitude de rôles **Ansible** pensés autour de la même phylosophie : une installation et une configuration simple d'un environnement serveur.

Si vous n'êtes pas famillier avec **Ansible**, je vous encourage à [découvrir ce magnifique outil](http://docs.ansible.com/ansible/index.html).

## Pourquoi monitorer

???

## La stack

### Telegraf

[Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) est une collecteur de données créer par les créateur d'**InfluxDB** : [InfluxData](https://www.influxdata.com/). Il permet de collecter des données systèmes (CPU, mémoire, I/O, disque, ...) et dispose de très [nombreux plugins](https://github.com/influxdata/telegraf#input-plugins) d'entrées (pour collecter) et de sortie (pour stocker).

### InfluxDB

[InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) est une base de données écrite en Go spécialisé dans le stockage de métriques et d'événements. Egalement développé par [InfluxData](https://www.influxdata.com/), l'integration avec **Telegraf** est très facile.

### Grafana

[Grafana](http://grafana.org/) est une des références parmis les dashboards de métriques. Il permet de réaliser des graphiques à partir d'une multitudes de sources de données.

## Provisonning

### Playbook

Vous devez installer les roles suivant :

{{< highlight yaml >}}
- src: manala.apt
- src: manala.telegraf
- src: manala.influxdb
- src: manala.grafana
{{< /highlight >}}

puis les ajouter à votre playbook :

{{< highlight yaml >}}
---

- hosts: all
  roles:
    - role: manala.apt
    - role: manala.influxdb
    - role: manala.telegraf
    - role: manala.grafana
{{< /highlight >}}

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention, jouez bien les rôles dans cet ordre là. Le rôles <code>manala.apt</code> doit être en premier car il va configurer les dépots. Telegraf doit être installer après InfluxDB car il va y créer sa base de données.
</div>

### Configuration

Dans ```group_vars```, la configuration suivante permet d'indiquer que nous installer d'InfluxDB, Telegraf et Grafana via les dépôts ```influxdata``` et ```grafana``` plutôt que part les dêpot Debian. Celà nous permet d'obtenir les dernières versions de ces logiciels.

{{< highlight yaml >}}
manala_apt_preferences:
  - influxdb@influxdata
  - telegraf@influxdata
  - grafana@grafana
{{< /highlight >}}

Il faut ensuite configurer le role [manala.telegraf](https://github.com/manala/ansible-role-telegraf) :

{{< highlight yaml >}}
manala_telegraf_config:
  - agent:
    - hostname: "{{ ansible_fqdn }}"
    - quiet: true

manala_telegraf_configs_exclusive: true
manala_telegraf_configs:
  - file:     output_influxdb.conf
    template: configs/output_influxdb.conf.j2
    config:
      - urls: ["http://localhost:8086"]
      - database: telegraf
      - username: telegraf
      - password: password

  - file:     input_system.conf
    template: configs/input_system.conf.j2

  - file:     input_cpu.conf
    template: configs/input_cpu.conf.j2

  - file:     input_mem.conf
    template: configs/input_mem.conf.j2

  - file:     input_disk.conf
    template: configs/input_disk.conf.j2

  - file:     input_diskio.conf
    template: configs/input_disk.conf.j2

  - file:     input_net.conf
    template: configs/input_net.conf.j2
{{< /highlight >}}

La configuration du fichier ```output_influxdb.conf``` indique dans quel moyen de stockage **Telegraf** doit envoyer les données collectées. Ici on indique l'url de API d'**InfluxDB** ainsi que le nom et les identifiants de la base de données à utiliser.

Les fichiers ```input_*.conf``` suivant permettent de configurer les métriques à collecter. Le rôles est fourni avec des fichiers de configurrations pour les plusieurs métriques mais vous pouvez en ajouter vos propres fichiers de configuration.

* cpu
* disk
* diskio
* haproxy
* mem
* net
* swap
* system

Les rôles [manala.influxdb](https://github.com/manala/ansible-role-influxdb) et [manala.grafana](https://github.com/manala/ansible-role-grafana) ne nécessite pas de configuration particulière pour fonctionner.

Je vous encourage néanmoins à jeter un oeil à la configuration de ses deux rôles si vous souhaitez aller plus loin, notamment concernant la sécurité des deux outils ou l'activation de fonctionnalités de Grafana.

## Prise en main

### InfluxDB

InfluxDB dispose d'une interface en ligne de commandes à la manière de ```mysql``` pour exécuter des requêtes. Si vous vous connectez en SSH à la machine que vous avez provisonnez, vous devriez pouvoir l'interroger. Vous pouvez par exemple lister les métriques de la base de données "telegraf".

{{< highlight bash >}}
$ influx -execute 'SHOW MEASUREMENTS' -database="telegraf"
name: measurements
name
----
cpu
disk
diskio
kernel
mem
net
processes
swap
system
{{< /highlight >}}

Vous devriez voir la liste des métriques que vous aviez configurées plus haut dans le role ```manala.telegraf```

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Je ne parle intentionnellement pas de l'interface web d'InfluxDB habituellement disponible sur le port 8083 car celle ci est <a  href="https://docs.influxdata.com/influxdb/v1.1/administration/differences/#deprecations">actuellement dépréciée et désactivé par defaut</a> (version 1.1) et disparaitra des versions suivantes.
</div>

### Grafana

Par defaut **Grafana** est accesible sur le port ```3000``` avec pour identifiant et mot de passe "admin" / "admin". Vous accédez alors au "Home Dashboard". Avant toute chose il faut ajouter notre base de données InfluxDB comme source de données. Pour celà dans le menu, sélectionné *Data Sources* puis *Add data source*. Nommez votre source, sélectionner le type "InfluxDB", renseigner l'url ```http://localhost:8086``` et le nom de base de données ```telegraf```. Par default il n'y a pas d'identifiant ni de mot de passe sur la base de données. Cliquez sur *Save and test* et si tout va bien vous devriez obtenir le message *Data source is working*.

A partir de la vous pouvez créer votre premier *dashboard* (Menu > Dashboard > New). Pour avoir rapidement une base, vous pouvez également importer (Menu > Dashboard > Import) <a href="https://gist.github.com/maximecolin/ae5876ff844ce6a5dca95bc179bfa72d" target="_blank">cette configuration de dashboard</a> que j'ai configuré pour vous.

<figure>
    <img src="/fr/images/posts/2016/monitoring-grafana.jpg" alt="Dashboard Grafana de monitoring système" />
    <figcaption style="text-align:center;font-style:italic;">Dashboard Grafana de monitoring système</figcaption>
</figure>

## Pour allez plus loin

### Provisionner les datasources et les dashboards

Une fois que vous avez configurer vos *datasources* et créer vos *dashboard* vous aurez peut être le souhait de les intégrer à votre provisonning afin d'automatiser leur configuration. Le rôle ```manala.grafana``` permet celà. 

Pour configurer une *datasource*, renseigner les mêmes informations que dans le formulaire de l'administration de **Grafana** :

{{< highlight yaml >}}
manala_grafana_datasources_exclusive: true
manala_grafana_datasources:
  - name:      telegraf
    type:      influxdb
    isDefault: true
    access:    proxy
    basicAuth: false
    url:       http://localhost:8086
    database:  telegraf
    username:  ''
    password:  ''
{{< /highlight >}}

Pour configurer un *dahsboard*, indiquer le chemin vers le fichier d'export JSON du dashboard et renseigner les ```intputs``` utilisés par celui-ci :

{{< highlight yaml >}}
manala_grafana_dashboards_exclusive: true
manala_grafana_dashboards:
    - template: "{{ playbook_dir }}/templates/grafana/dashboards/system.json"
      inputs:
        - name:     "DS_TELEGRAF"
          pluginId: "influxdb"
          type:     "datasource"
          value:    "telegraf"
      overwrite: true
{{< /highlight >}}

### Proxy pass

Si vous destinez votre instance de **Grafana** à des utilisateurs par forcement téchnique, il peut être intéressant d'avoir une url une peu plus sexy qu'un numéro de port à la fin de votre domain. Vous pouvez opter pour un sous-domaine ou un chemin dedier en [placant **Grafana** derière un reverse proxy](http://docs.grafana.org/installation/behind_proxy/).

Vous pouvez configurer un reverse proxy grâce au role [manala.nginx](https://github.com/manala/ansible-role-nginx). 

Par exemple pour exposer **Grafana** sur l'url ```http://grafana.foobar.com``` :

{{< highlight yaml >}}
manala_nginx_config_template: config/http.{{ _env }}.j2

manala_nginx_configs_exclusive: true
manala_nginx_configs:
  # Php fpm
  - file:     app_php_fpm
    template: configs/app_php_fpm.{{ _env }}.j2
  # Grafana
  - file:     grafana.conf
    template: configs/server.{{ _env }}.j2
    config:
      - server_name: grafana.foobar.com
      - location /:
        - proxy_pass: http://localhost:3000
{{< /highlight >}}

Il faut également indiquer le domain à **Grafana** en ajouter la configuration suivante :

{{< highlight yaml >}}
manala_grafana_config:
  - server:
    - domain: grafana.foobar
{{< /highlight >}}

### Sécuriser Grafana

Une première mesure est de changé l'identifiant et le mot de passe administrateur de **Grafana** et de désactivé la création de compte. Dans votre fichier de configuration **Ansible** :

{{< highlight yaml >}}
manala_grafana_config:
  - security:
    - admin_user: foobar
    - admin_password: foobar
  - users:
    - allow_sign_up: false
{{< /highlight >}}

<div style="border-left: 5px solid #ffa600;padding: 20px;margin: 20px 0;">
    Attention, l'utilisateur administrateur est créé au premier démarrage de <strong>Grafana</strong>, vous ne pourrez donc pas changer son identifiant ou son mot de passe via la configuration après le premier provisioning. Vous devrez alors passer par la page <em>profile</em> dans l'interface de <strong>Grafana</strong>.
</div>

Il est possible de mettre en place des systèmes d'authentification tiers comme Google, GitHub ou votre propre OAuth.

Vous pouvez également changer le port de l'interface web qui est à ```3000``` par defaut :

{{< highlight yaml >}}
manala_grafana_config:
  - server:
    - http_port: 3000
{{< /highlight >}}

Pour une configuration encore plus poussez, vous pouvez lire la [documentation de Grafana](http://docs.grafana.org/installation/configuration/).


### Sécuriser InfluxDB

???

## Conclusion

Grâce aux rôles de [Manala](http://www.manala.io/) j'ai pu créer simplement le provisonning d'une stack de monitoring en [moins de 100 lignes de configuration](https://gist.github.com/maximecolin/acf6dd12dff72640a2b224cbb3934c4d). Au besoin, grâce au provisonning, je peux répliquer cette stack sur n'importe quel serveur en quelques minutes.

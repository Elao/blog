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

## Résultat

<figure>
    <img src="/fr/images/posts/2016/monitoring-grafana.jpg" alt="Dashboard Grafana de monitoring système" />
    <figcaption style="text-align:center;font-style:italic;">Dashboard Grafana de monitoring système</figcaption>
</figure>




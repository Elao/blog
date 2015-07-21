# Hugo

## Installing Hugo with brew (binary)

`brew install hugo`

## Using Hugo inside vagrant VM

`vagrant up`

# Run Hugo (Launching server only if you are not using the vagrant VM)

`hugo server --theme=hyde --buildDrafts --watch --ignoreCache=true`

# Writing a post

## Categories

3 main categories are available

* Infra (content/infra)
* Dev   (content/dev)
* Actu  (content/news)

You need to create your post inside one of them.

## Create a new post

### Yourself

Simply create your markdown file (.md extension) into the choosen category (content/infra, content/dev ... )
And add the front matter skeleton:

```
---
type:           "post"
title:          "My title"
date:           "2015-01-16"
publishdate:    "2015-01-16"
draft:          false
slug:           "slug-of-my-post"
description:    "Description of my post."

thumbnail:      ""
tags:           ["x", "y"]
categories:     ["x", "y"]

author_username:    "elao"

---
```

### With Hugo 

`hugo new dev/my-first-post.md`

The new file is located at `content/dev/my-first-post.md`

## Code highlighting

Hugo is using `Python Pygments` package for code highlighting so you can highlight your code with the dedicated tag like this:

```
{{< highlight php >}}
{{< /highlight >}}
```

## What about my medias

All media files linked to an article need to be stored into the static directory and more precisely into the static/images/posts (Group by year of publication)

To display a media into a post use Hugo shortcode `figure` like the following:

```
<p class="text-center">
    {{< figure src="/images/posts/2014/proxmox_partition_elao_1000.png" title="Partitionnement personnalisé" alt="Partitionnement-d-un-serveur-proxmox - Partitionnement personnalisé">}}
</p>
```

## Add a new author file

You need to add a new yaml file into data/authors with the following informations:

```
en:
  display_name: Elao
  short_bio:    ""
  long_bio:     ""
  job_title":   "Agence web experte Symfony"

fr:
  display_name: Elao
  short_bio:    ""
  long_bio:     ""
  job_title:    "Agence web experte Symfony"

social:
  website:         http://www.elao.com
  twitter:         Elao
  github:          Elao
  email:           your-email@elao.com
  avatar_url:      /images/logo.svg
  google_plus_id:  "~"
```




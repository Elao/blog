# Hugo

We finally use Docker to handle the container stuff, so you will need ... [docker](http://www.docker.com/products/docker#/mac) to be able to work on the blog.

## Launching hugo (watch mode)

### First run

`make install`

### Server launch
`make watch`

### I don't see my assets !!
`make build && make watch`

(By default the french blog is loaded, you can easily switch to the english part by updating the locale in the url)

# Writing a post

## Categories

4 main categories are available into two i18n folders (EN/FR)

* Infra (content/infra)
* Dev   (content/dev)
* Elao  (content/news)
* Tech  (content/tech)

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

thumbnail:      "/images/posts/thumbnails/path_to_file"
header_img:     "/images/posts/headers/path_to_file"
tags:           ["x", "y"]
categories:     ["x", "y"]

author_username:    "elao"
---
```

### With Hugo

`hugo new dev/my-first-post.md`

The new file is located at `content/dev/my-first-post.md`

### IMPORTANT
If you wish to write a post in english you need to include the locale as part of the filename like this:

`my-awesome-blogpost.en.md`

## Where to put my media files ?

ALL media files to be stored into `static/images`
Medias are moved when static files are build in public directory. Be careful to the quality and size of the media, don't worry about optimization it's handle by the build/optimize tasks.

## What about my article medias ?

All media files linked to an article need to be stored into the static directory and more precisely into the static/images/posts (Group by year of publication)
To display a media into a post use Hugo shortcode `figure` like the following:

```
<p class="text-center">
    {{< figure src="/images/posts/2014/proxmox_partition_elao_1000.png" title="Partitionnement personnalisé" alt="Partitionnement-d-un-serveur-proxmox - Partitionnement personnalisé">}}
</p>
```

## Code highlighting

Hugo is using `Python Pygments` package for code highlighting so you can highlight your code with the dedicated tag like this:

```
{{< highlight php >}}
{{< /highlight >}}
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
  avatar:          ~
  google_plus_id:  "~"
```

## Expose your current branch (for review)

Launch a local serveur on port 8080

    make expose

The blog is now accessible by everyone in the open-space on [http://192.168.1.xx:8080/fr](http://192.168.1.xx:8080/fr) (where xx is your local IP address).

## You have an old version of the docker image
If you have cloned the repository a long time ago, your docker image could be an old one.
To have the last version of the image, you can execute the following command:
`docker pull manala/hugo-debian`

## Publish an article
Your post is good to go ? Create a PR and ask for review to a team member once it's done you're ready going to production.

### Going to production

#### Sync only files (you don't had any images)
`make deploy@prod`

#### Sync files and optimize images
`make deploy_and_optimize@prod`

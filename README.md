# Hugo

Reference : [https://gohugo.io/overview/quickstart/](https://gohugo.io/overview/quickstart/)

We finally use Docker to handle the container stuff, so you will need ... [docker](http://www.docker.com/products/docker#/mac) to be able to write articles for the blog.

## Launching hugo (watch mode)

### First run

Make sure _docker is running_! Then:

`make setup`

### Server launch
`make watch`

The blog is now available at [http://localhost:1313/](http://localhost:1313/)

(By default the french blog is loaded, you can easily switch to the english version by updating the locale in the url)

# Writing a post

## Categories

5 main categories are available in the `content` folder:

* Infra   (content/infra)
* Dev     (content/dev)
* Elao    (content/news)
* Tech    (content/tech)
* Methods (content/methodo)

You must create your post inside one of them.

## Create a new post

### Yourself

Simply create your markdown file (.md extension) into the chosen category (content/infra, content/dev ... )
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

All media files must be stored into `static/images`
Media are moved when static files are built into the `public` directory. Be careful to the quality and size of the media, don't worry about optimization it's handled by the `build/optimize` tasks.

## What about my article media ?

All media files linked to an article need to be stored into the static directory and more precisely into the `static/images/posts` (Grouped by year of publication)
To display a media into a post, use Hugo shortcode `figure` like the following:

```
<p class="text-center">
    {{< figure class="text-center" src="/images/posts/2014/proxmox_partition_elao_1000.png" title="Partitionnement personnalisé" alt="Partitionnement-d-un-serveur-proxmox - Partitionnement personnalisé">}}
</p>
```

## Code highlighting

Hugo is using `Python Pygments` package for code highlighting so you can highlight your code with the dedicated tag like this:

```
{{< highlight php >}}
  <?php
    // Your code goes here ...
{{< /highlight >}}
```

> :warning: for PHP language, make sure you open a php tag `<?php` in order to obtain syntax coloration

## Add a new author file

You need to add a new yaml file into `data/authors` with the following information:

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

## Summary

You can generate a summary for your article by setting this variable in the header:

```diff
slug:           "my-article"
description:    "My article"
+ summary:        true
```

The summary will be constructed based on all the titles in your article.

## Expose your current branch (for review)

Every branch pushed to remote `origin` is deployed to staging in order to share your work in progress with the rest of the team :

`http://<my-branch>.blog.elao.elao.ninja/`

> :warning: The branch name is normalized :
> - all special characters such as `_` are replaced with an hyphen (`-`)
> - slash-separated parts (`/`) are reversed and made dot-separated. Example: `dev/vue-js-with-symfony` will translate into `vue-js-with-symfony.dev`

As an example, here is the staging URL for the `master` branch :

http://master.blog.elao.elao.ninja/

## You have an old version of the docker image
If you have cloned the repository a long time ago, your docker image could be deprecated.
In order to obtain the last version of the image, you can execute the following command:
`make update`

## Publish an article
Your post is ready to be published ? Create a PR and ask for review to a team member. Once it's done, you're ready for production.

### Going to production

Ensure you have installed ansible deploy role:

```shell
ansible-galaxy install --roles-path deploy/roles --role-file deploy/roles/requirements.yaml --force
```

> :warning: The deploy tasks will first run the build (assets, image optimization, compiling blog posts to HTML, etc) **locally** and push compiled files to production from your local filesystem. So make sure that your current branch is `master` and that you are up-to-date with `origin/master`.

```shell
  git checkout master
  git pull
```

Then:

`make deploy.production`

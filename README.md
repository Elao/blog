# Hugo

## Installing Hugo (only if you want run the server localy)
Your password is mandatory to install Python Pygments.

`make install`

## Using Hugo inside vagrant VM (It's note the good way to wrote a post due to filecache)

`vagrant up`

# Run Hugo Server (Only if you are not using the vagrant VM)

`make server-start`

## Run Hugo Server (In FR locale)

`make server-start-fr`

## Run Hugo Server (In EN locale)

`make server-start-en`

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

## Where to put my media files ?

ALL media files to be stored into `static/images`
Medias are moved when static files are build in public directory. Be careful to the quality of the media, don't worry about optimization it's handle by the build/optimize tasks.

## What about my article medias

All media files linked to an article need to be stored into the static directory and more precisely into the static/images/posts (Group by year of publication)
To display a media into a post use Hugo shortcode `figure` like the following:

```
<p class="text-center">
    {{< figure src="[locale]/images/posts/2014/proxmox_partition_elao_1000.png" title="Partitionnement personnalisé" alt="Partitionnement-d-un-serveur-proxmox - Partitionnement personnalisé">}}
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

## Publish an article
Your post is good to go ? Create a PR and ask for review to a team member once it's done you're ready going to production.

### Going to production

`make deploy@prod`

### If you are working localy (OSX)

You need to be sure to have those tools installed:

- optipng (`brew install optipng`)
- imagemagick (`brew link jpeg --overwrite && brew install imagemagick`)
- jpegtran

#### Installing jpegtran
```
cd /tmp && \
wget http://jpegclub.org/jpegcrop.tar.gz && \
tar xvfz jpegcrop.tar.gz && \
cd /tmp/jpegcrop/jpeg-9b && \
./configure && \
make && \
sudo make install
```




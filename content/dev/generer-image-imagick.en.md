---
type:           "post"
title:          "Dynamically generate images with PHP & IMagick"
date:           "2019-06-07"
publishdate:    "2019-06-12"
draft:          false
slug:           "dynamically-generate-images-imagick"
description:    "A quick overview of PHP's IMagick native extension"

thumbnail:      "/images/posts/thumbnails/dynamically-generate-images-imagick.jpg"
header_img:     "/images/posts/headers/dynamically-generate-images-imagick.jpg"
tags:           ["IMagick"]
categories:     ["Dev", "PHP", "Symfony"]

author_username:    "dgauthier"
---

Recently, I had to dynamically create images in PHP. Naturally, I turned towards PHP native extension: [_IMagick_](https://www.php.net/manual/en/book.imagick.php). 

At first, it seemed thorough and easy to use (and it is), but I quickly realized it was desperately lacking documentation. That's why I decided to give you a quick overview of basic but crucial functions, of the way they work and how to fix common errors. 

# Installation
I'm not going to show you here how to install [_IMagick_](https://www.php.net/manual/en/book.imagick.php), since we probably don't work with the same programming environment and all I had to do was to update my virtual machine's provisionning. 

However, you can find some help on the [dedicated documentation page](https://www.php.net/manual/en/imagick.setup.php), particularly in contributor's notes (your new best friend).

# Create or open an existing image
Creating (or opening an existing image) with _IMagick_ is really simple, you just need to instanciate the `IMagick` class, and you're done. 
For this article's sake, I'll use an existing image which we'll improve throughout the demonstration.

{{< highlight php >}}
    <?php
            
        use IMagick;
        
        class MyAwesomeImageGenerator
        {
            public function generate(): string
            {
                // Use an existing image
                // In order to create an image from scratch, just don't provide any path
                $image = new IMagick('../assets/awesome/images/bouboule.jpg');
                // Setting filename also sets the target directory
                $image->setFilename('./awesome/bouboule_enhanced.jpg');
            
                // Create actual file
                file_put_contents($image->getFilename(), $image);
            
                // Return image name
                return $image->getFilename();
            }
        }
{{< /highlight >}}

As you can see in the following, image has succesfully been created and exported in the target directory.

![1-image-successfully-created](/images/posts/2019/generate-image-imagick/1-image-successfully-created.png)

I chose to actually write the file on the disk, but if you want to simply display it, just replace the `file_put_contents()` line by this code :

{{< highlight php >}}
    
    <?php
        header("Content-Type: image/png");
        echo $image->getImageBlob();
    
{{< /highlight >}}

Anyway, you should be able to see the image you picked in your browser right now.

![Bouboule enhanced](/images/posts/2019/generate-image-imagick/2-bouboule-enhanced-display.png)

_Meet Bouboule, Elao's favourite bird ❤️_

#### Troubleshooting
If something went wrong, you may not see the selected picture, but a blank (or colored) screen, without any error messages. If you are as lucky as I was, you'll find something in your error log, but if you don't, know that it probably comes from the path to the image that you provided.

You may have noticed I gave the constructor a _relative_ path. In my case, the root of this relative path is the `public` folder of the project (I work with Symfony). You could also provide an absolute path, using the PHP `realpath()` function but you'd still need to provide the correct relative path.

If you don't know exactly where the root folder is in your project, and you don't feel like guessing, you can easily find out by creating and saving an image without providing any path, just like it's done in the code below:  

{{< highlight php >}}

    <?php
            
        use IMagick;
        
        class MyAwesomeImageGenerator
        {
            public function generate(): string
            {
                $image = new IMagick();
                
                file_put_contents('test.jpg', $image);
            }
        }
{{< /highlight >}}

> During my research, I've found a [website called phpimagick](https://phpimagick.com/) which provides you with example and let you try out some code online. It has proved itself useful a bunch of times, so if you need more insight, it may help you too. 

# Improve the newly created image
Most of the time, adding elements to the image comes down to instanciate and draw `IMagickDraw` objects on `IMagick` instance.

## Add an overlay
In what follows, I'll create an overlay (basically, draw a rectangle), with some transparency and display it on the right part of the image.  

{{< highlight php >}}
    
    <?php
        // Define the rectangles coordinates
        $startX = 1100;
        $endX = 2000;
        $startY = 0;
        $endY = 1080;

        // Add overlay
        $overlay = new IMagickDraw();
        $overlay->setFillColor('#fff');
        $overlay->setFillOpacity(0.5);
        $overlay->rectangle(
            $startX,
            $startY,
            $endX,
            $endY
        );
    
        // Draw overlay on image
        $image->drawImage($overlay);
{{< /highlight >}}

If you read the documentation, you'll see that [setFillColor()](https://www.php.net/manual/en/imagickdraw.setfillcolor.php), expects a [IMagickPixel](https://www.php.net/manual/en/class.imagickpixel.php) object as argument. However, it is possible (and much easier) to provide a string, with the following content:  

* A color's name (such as "white")
* An hexadecimal color code (such as "#FFFFFF"), just like I did
* A call to rgb() function
* A call to rgba() function, to handle color and opacity all at once. In this case, you won't need to use [setFillOpacity()](https://www.php.net/manual/en/imagickdraw.setfillopacity.php) anymore.

> You should know that there's also a method name [colorizeImage()](IMagick::colorizeImage), which should be helpful if you don't need much customization. 

#### Troubleshooting
Usually, drawing on an existing image is quite simple and function names are really descriptive. But sometimes, when the shape is complex, it can appear as rough and edgy. In this case, you can manipulate a stroke to ease the contour, thanks to functions like [setStrokeColor()](https://www.php.net/manual/en/imagickdraw.setstrokecolor.php), [setStrokeWidth()](https://www.php.net/manual/en/imagickdraw.setstrokewidth.php), [setStrokeOpacity()](https://www.php.net/manual/en/imagickdraw.setstrokeopacity.php) and last, but definitely not least, [setStrokeAntiAlias()](https://www.php.net/manual/en/imagickdraw.setstrokeantialias.php).  

## Add text
Adding text is pretty similar to adding shapes to your image. It also consists in creating an `IMagickDraw` object, setting its caracteristics, the only difference being that you also need to annotate this object with the text you want to display. Then again, you draw this object on the image.

{{< highlight php >}}
    
    <?php

        // Create a text draw
        $text = 'Bouboule';
        
        $title = new IMagickDraw();
        $title->setFillColor('#fff');
        $title->setFont('../assets/awesome/fonts/montserrat-bold.woff');
        $title->setSize(140);
        $title->setStrokeAntialias(true);
        $title->setTextAntialias(true);
               
        // Annotate object with text at the given coordinates 
        $title->annotation(1200, 150, $text);

        // Draw text on image
        $image->drawImage($title);
{{< /highlight >}}

> Depending on the font you chose, you could need to use [setTextAntiAlias()](https://www.php.net/manual/en/imagickdraw.settextantialias.php), which will improve the render of the text.

#### Troubleshooting
If you can't see the text on the image, it could be dued to several causes :

* The coordinates you used when annotating were not accurate. In this case, you'll want to make sure that they fit the main image's size. In order to do that, you could try to display the text at the top left of the image (x: 0, y: 0) or try to force image size using [resizeImage()](https://www.php.net/manual/en/imagick.resizeimage.php).

* It may seem obvious, but maybe you just don't see the text because of its color. Try to use something simple like `#000` or `#FFF`.

* The font you used is not recognised or its path is incorrect. To fix it, you could :
    * List all fonts known by IMagick using [queryFonts()](https://www.php.net/manual/en/imagick.queryfonts.php).
    * Try to display text using one of these fonts in [setFont()](https://www.php.net/manual/en/imagickdraw.setfontsize.php) (just call the font by its name, it's supposed to work).
    * Try to provide an absolute path instead of a relative one (once again, thanks to PHP `realpath()` function).
    * If nothing of the preceding works, try to actually install the font you want to use on your server, instead of using it as an external font. It should then be listed by [queryFonts()](https://www.php.net/manual/en/imagick.queryfonts.php).  

Don't forget that you may have error logs, and that they could prove very helpful.  

> ⚠️ Method setFont() is defined in both `IMagick` and `IMagickDraw` classes, be careful when reading the documentation !    

## Add another image
Once again, it's pretty simple to add an image into the existing one. You'll actually create a new `IMagick` object, just like you did at the beginning, and then use [compositeImage()](https://www.php.net/manual/en/imagick.compositeimage.php) to integrate it to the first image, setting its position by providing its origin coordinates. 

{{< highlight php >}}
    
    <?php
        $logo = new IMagick(realpath('../assets/awesome/images/logo-elao.jpeg'));
        $logo->resizeImage(100, 0, IMagick::FILTER_UNDEFINED, 1);
        $image->compositeImage(
            $logo = $this->drawLogo(),
            IMagick::COMPOSITE_DEFAULT,
            10,
            10
        );

{{< /highlight >}}
 
## Relative positionning
If, just like me, you need to generate images with dynamic content, you'll probably need to adjust your elements' display relatively to one another. Several functions can help you achieve your goal :

* [getImageHeight()](https://www.php.net/manual/en/imagick.getimageheight.php) will return `$image` height in pixels.
* [getImageWidth()](https://www.php.net/manual/en/imagick.getimagewidth.php) will return `$image` width in pixels.
* [queryFontMetrics()](https://www.php.net/manual/en/imagick.queryfontmetrics.php) will return several info concerning an `IMagickDraw` text annotation.

{{< highlight php >}}
    
    <?php
        // $title is the ImagickDraw object we used earlier
        // $text is the text we annotated on $title
        $titleMetrics = $image->queryFontMetrics($title, $text);

{{< /highlight >}}

If you dump `$titleMetrics` content, you should see something like that :

![Font metrics](/images/posts/2019/generate-image-imagick/3-font-metrics.png)

#### Troubleshooting

Metrics content can be obscure, and documentation won't help you much in this case, but after a some research, and thanks to contributors notes, I think I can now understand it with an acceptable level of confidence :

* `characterWidth` et `characterHeight` respectively represent a character's maximum width in height, in `em`. Most of the time, it's the same number you provided when setting font size.
* `ascender` & `descender` are expressed in pixels. `ascender`, in this case, stands for the part of the caracter that is _above_ baseline, while `descender` stands for the part of the character that is _below_ baseline. 
* `textWidth` & `textHeight` respectively represent text's width and height, in pixels, taking into account selected font and fontsize. `textHeight` equals the sum of `ascender` & `descender` absolute values. 
* `maxHorizontalAdvance` stands for the maximal space between the start of the current character and the start of the next one. It is expressed in pixels.
* `boundingBox` gives you the coordinates of the box containing the text. It seems that it's only relevant for one character.
* `originX` et `originY` are the next character's coordinates values.

> Some say that [getImageHeight()](https://www.php.net/manual/en/imagick.getimageheight.php) and [getImageWidth()](https://www.php.net/manual/en/imagick.getimagewidth.php) don't take into account whether or not an image has been resized using either [resizeImage()](https://www.php.net/manual/en/imagick.resizeimage.php) or [scaleImage()](https://www.php.net/manual/en/imagick.scaleimage.php), but it worked just fine in my case, so you should probably check for yourself if you are in doubt.  

## The end

![Bouboule-enhanced-1,0-small](/images/posts/2019/generate-image-imagick/4-bouboule-enhanced-1.0-small.png)


---
type:           "post"
title:          "From react-native init to app stores real quick"
date:           "2017-10-31"
publishdate:    "2017-10-31"
draft:          false
slug:           "from-react-native-init-to-app-stores-real-quick"
description:    "From react-native init to stores real quick"

thumbnail:      "/images/posts/thumbnails/from-react-native-init-to-app-stores-real-quick.jpg"
header_img:     "/images/posts/headers/from-react-native-init-to-app-stores-real-quick.jpg"
tags:           ["react", "react native", "mobile"]
categories:     [dev"]

author_username: "tjarrand"

---

Hi, I'm Thomas and I'm gonna show you how to build and release a React Native app to iOS and Android stores on macOS.

## Our goals

What we aim to accomplish:

* Automated build process that generates signed and __ready-for-stores__ release builds.
* Handling different environments (development, staging, production) with different variables (e.g. URL of the back-end API).

So let's get to it.

## Prerequisite

###  iOS

You'll need a [Apple ID](https://appleid.apple.com/#!&page=signin) and [Xcode is installed on you mac](https://facebook.github.io/react-native/docs/getting-started.html#xcode).

Also ensure that you agreed to Apple's latest terms and conditions (just launch Xcode and click _Agree_).

### Android

1. Get Android Studio with [tools required by React Native](https://facebook.github.io/react-native/docs/getting-started.html#1-install-android-studio)
2. Launch Android Studio and install [Android SDK and other required libraries](https://facebook.github.io/react-native/docs/getting-started.html#2-install-the-android-sdk) _React Native requires Android 6.0 and SDK 23.0.1_
3. Configure your [Android Home environment variable](https://facebook.github.io/react-native/docs/getting-started.html#3-configure-the-android-home-environment-variable) by adding the following lines in your bash profile file:

{{< highlight bash >}}
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
{{< /highlight >}}

## Create your app

We won't be using [the default react-native way](https://facebook.github.io/react-native/docs/getting-started.html) that relies on [Expo](https://expo.io), a container to run your React-Native in.

While [Expo](https://expo.io) might be fine for experimenting and quickly bootstraping an App, it's not compatible with setting up a _real release process_ as stated in our goals.

So instead, let's go to the [Building Projects with Native Code](https://facebook.github.io/react-native/docs/getting-started.html#the-react-native-cli) documentation:

Install the Rect Native init tool:

{{< highlight bash >}}
npm install -g react-native-cli
{{< /highlight >}}

Create your app and be careful to __choose a name that contains no dots, spaces or other special characters__.

{{< highlight bash >}}
react-native init AcmeApp
cd AcmeApp
{{< /highlight >}}

## Environments and variables

To build a release of the app, we need to give it a few pieces of information:

- A __unique identifier__: `com.acme.app`
- A __version number__: `1.0.0`
- A __build number__: `1`
- Any __app-releted variables__ we need.

#### Unique identifier

Note the format of the unique identifier: a reverse domain name, starting with `com`, then the vendor name and then the app name.

I strongly recommend that you follow this format and avoid any special character.

This idientifier must not be already used on Google Play Store or Apple's App Store.

Once published, an app can't change its identifier, so choose a name that can live through the whole life of the app.
Don't worry though, it's only a technical identifier, it will not be displayed to the public anywhere and you'll have a _Display name_ for that and this one can change anytime you need.

#### Version Number

The version number must follow the semver format `major.minor.patch`.

#### Build Number

The build number is just an integer as simple as `1`.

You'll increment build number _every time you publish a release_.
You can't upload a release that has a build number inferior or equal to any build you ever uploaded for this app.

#### App related variables

We might also need some __app-releated variables__ like the address of the API providing the data for the app.

Such variables will likely have different values in different environments.

For example, we want to call `http://api.app.acme.test` in development mode in the simulator, and `https://api.app.acme.com` in a production release for the stores.

### Enable vendor name in Android

In the `/android` folder, replace all occurrences of `com.acmeapp` by `com.acme.app`

Then change the directory structure with the following commands:

{{< highlight bash >}}
mkdir android/app/src/main/java/com/acme
mv android/app/src/main/java/com/acmeapp android/app/src/main/java/com/acme/app
{{< /highlight >}}

### React Native Config

For setting and accessing these variables whereever we need it, I recommend using [react-native-config](https://github.com/luggit/react-native-config)

Install it with:

{{< highlight bash >}}
yarn add react-native-config
react-native link react-native-config
{{< /highlight >}}

Then create an Env file for each environnment in the root folder of the project, with the following suggested variables:

__.env.development__

{{< highlight ini >}}
APP_ID=com.acme.app
APP_ENV=development
APP_VERSION=0.1.0
APP_BUILD=1
API_HOST=http://api.app.acme.local
{{< /highlight >}}
__.env.staging__

{{< highlight ini >}}
APP_ID=com.acme.app
APP_ENV=staging
APP_VERSION=0.1.0
APP_BUILD=1
API_HOST=http://api.app.acme.staging
{{< /highlight >}}
__.env.production__

{{< highlight ini >}}
APP_ID=com.acme.app
APP_ENV=production
APP_VERSION=0.1.0
APP_BUILD=1
API_HOST=http://api.app.acme.com
{{< /highlight >}}

## Configure the release

### Generate an Adroid Signing Key

Edit your local gradle config file:

{{< highlight bash >}}
vim ~/.gradle/gradle.properties
{{< /highlight >}}

Fill it with the following lines:

{{< highlight ini >}}
MY_RELEASE_STORE_FILE=my_release.keystore
MY_RELEASE_KEY_ALIAS=my_release
MY_RELEASE_STORE_PASSWORD={Generate a 32 characters password}
MY_RELEASE_KEY_PASSWORD={Generate another 32 characters password}
{{< /highlight >}}
_Note: you'll need to [generate 2 passwords](https://passwordsgenerator.net/)_

Now generate the keystore key file:

{{< highlight bash >}}
keytool -genkey -v -keystore ~/.gradle/my_release.keystore -alias my_release -keyalg RSA -keysize 2048 -validity 10000
{{< /highlight >}}

Follow the instructions as below:

{{< highlight bash >}}
Entrez le mot de passe du fichier de clés: {MY_RELEASE_STORE_PASSWORD}
Ressaisissez le nouveau mot de passe: {MY_RELEASE_STORE_PASSWORD}
Quels sont vos nom et prénom ? Jane Doe
Quel est le nom de votre unité organisationnelle ? Lyon
Quel est le nom de votre entreprise ? élao
Quel est le nom de votre ville de résidence ? Lyon
Quel est le nom de votre état ou province ? Rhones-Alpes
Quel est le code pays à deux lettres pour cette unité ? FR
Est-ce CN=Jane Doe, OU=Lyon, O=élao, L=Lyon, ST=Rhones-Alpes, C=FR ? oui
Entrez le mot de passe de la clé pour <my_release> {MY_RELEASE_KEY_PASSWORD}
Ressaisissez le nouveau mot de passe : {MY_RELEASE_KEY_PASSWORD}
{{< /highlight >}}

Finally, link the keystore to the project with a symbolic link:

{{< highlight bash >}}
ln -s ~/.gradle/my_release.keystore android/app/my_release.keystore
{{< /highlight >}}
### Configure the gradle build

Edit `android/app/build.gradle` and apply the following changes

Insert the following line on _line 2:_

{{< highlight groovy >}}
apply from: project(':react-native-config').projectDir.getPath() + "/dotenv.gradle"
{{< /highlight >}}

In the config block, replace the following lines:

{{< highlight diff >}}
defaultConfig {
-    versionCode 1
+    versionCode project.env.get("APP_BUILD") as Integer
-    versionName "1.0"
+    versionName project.env.get("APP_VERSION")
    // ...
    }
    {{< /highlight >}}

Between the `splits` and `buildTypes` blocks (should be line 118) add the following block :

{{< highlight groovy >}}
signingConfigs {
    release {
        storeFile file(MY_RELEASE_STORE_FILE)
        storePassword MY_RELEASE_STORE_PASSWORD
        keyAlias MY_RELEASE_KEY_ALIAS
        keyPassword MY_RELEASE_KEY_PASSWORD
    }
}
{{< /highlight >}}

Then add the `signingConfig` property in the `buildTypes > release` section (should be line 131)

{{< highlight groovy >}}
buildTypes {
    release {
        // ...
        signingConfig signingConfigs.release
    }
}
{{< /highlight >}}

### Configure the iOS build

Open your iOS project `iOS/AcmeApp.xcodeproj` with Xcode and select the root item __AcmeApp__ in the file browser on the left.

#### In the _General_ tab

In the _Identity_ section input the following values:

- __Bundle Identifier__: Your app unique identifier `com.acme.app` (instead of _org.reactjs.native.example.AcmeApp_)
- __Version__: `__RN_CONFIG_APP_VERSION`
- __Build__: `__RN_CONFIG_APP_BUILD`

In the _General_ > _Signing_ section:

- Select a __Team__

![](/images/posts/2017/from-react-native-init-to-app-stores-real-quick/xcode_config.png)

#### In the _Build Settings_ tab

In the _All_ section:

* Search for "preprocess"
* Set __Preprocess Info.plist File__ to `Yes`
* Set __Info.plist Preprocessor Prefix File__ to `${BUILD_DIR}/GeneratedInfoPlistDotEnv.h`
* Set __Info.plist Other Preprocessor Flags__ to `-traditional`

_If you don't see those settings, verify that "All" is selected at the top (instead of "Basic")._

![](/images/posts/2017/from-react-native-init-to-app-stores-real-quick/xcode_build_settings.png)

## Test our setup

Here's a simple homepage that displays the app version, build number, environment and platform.
You can open your `./App.js` file and replace its content with the following code:

{{< highlight javascript >}}
import React, { Component } from 'react';
import { Platform, Text, View, StyleSheet } from 'react-native';
import Config from 'react-native-config';

export default class App extends Component {
  static styles = StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
    },
    infos: {
      textAlign: 'center',
      color: '#333333',
    },
  });

  render() {
    const { styles } = App;
    const { APP_ENV, APP_VERSION, APP_BUILD } = Config;
    const { OS } = Platform;

    return (
      <View style={styles.container}>
        <Text style={styles.infos}>
          AcmeApp v{APP_VERSION} build {APP_BUILD}
        </Text>
        <Text style={styles.infos}>
          [{APP_ENV}] on {OS}
        </Text>
      </View>
    );
{{< /highlight >}}

### Quick launch commands

Start the react-native packager manually : `react-native start`

Now a simple `react-native run-iOS` should start your app in iOS simulator.

- `react-native run-iOS --simulator 'iPhone SE'`
  Run the app in the simulator on a specific device.
- `react-native run-iOS --device`
  Run the app on a real iPhone (that must be connected to the mac by USB).
- `react-native run-iOS --device --configuration Release`
  Run the app on a real iPhone as a release (fast and no debug, just like it will be in the store).
- `react-native run-android `
  Run the app on a any simulated or real android device found.
- `react-native run-android --variant=release `
  Run the app on a any simulated or real android device found, as a release.

What's more, we can now run the app in a _certain_ environment by specifying the `ENVFILE` that React Native must use:

| Develoment                               | Staging                                  | Production                               |
| ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| `ENVFILE=.env.development react-native run-iOS` | `ENVFILE=.env.staging react-native run-iOS ` | `ENVFILE=.env.production react-native run-iOS ` |
| ![](/images/posts/2017/from-react-native-init-to-app-stores-real-quick/AcmeApp_dev.png) | ![](/images/posts/2017/from-react-native-init-to-app-stores-real-quick/AcmeApp_staging.png) | ![](/images/posts/2017/from-react-native-init-to-app-stores-real-quick/AcmeApp_production.png) |

### Build store release

#### iOS release

{{< highlight bash >}}
ENVFILE=.env.production xcodebuild \
    -workspace ./iOS/AcmeApp.xcodeproj/project.xcworkspace \
    -scheme AcmeApp \
    -sdk iphoneos \
    -configuration AppStoreDistribution archive \
    -archivePath ./iOS/release/AcmeApp.xcarchive
{{< /highlight >}}

The archive will be available at `./iOS/release/AcmeApp.xcarchive` and you can open it in Xcode to build an IPA for development purpose or upload it to the App Store.

#### Android release

{{< highlight bash >}}
. ./.env.production && cd android && ./gradlew assembleRelease
{{< /highlight >}}

The APK will be available at `./android/app/build/outputs/apk/app-release.apk` and you can [upload it directly to the Play Store](https://play.google.com/apps/publish).

## Troubles?

Here's a aworking example of all we discussed above : https://github.com/Elao/AcmeApp

Note the handy [Makefile](https://github.com/Elao/AcmeApp/blob/master/Makefile) that hides all complex build and release commands behind simple make tasks like:  `make run android` or `make release-iOS`

## Store configuration

### Generate store icons

Apple's App Store and the Google Play Store both require that you provide icons for you app in various formats.

Fortunately, there are a few online-services that will generate those icons for you from a high-res source icon.

I personnaly use https://makeappicon.com

- Upload a high-res square icon (ideally `1536x1536 `).
- Enter an email (you don't have to subscribe to the newsletter).
- You will receive the icons by email.

#### Setup icons for iOS

Move the content of `iOS` in the following path in your project folder: `iOS/AcmeApp/Images.xcassets/`  (if asked, replace existing content with the new icons).

#### Setup icons for Android

Move the content of `android` in the following path in your projet folder: `android/app/src/main/res`  (if asked, replace existing content with the new icons).

### Google Play

#### Add an user

#### Create app

####  Handle Alpha / Beta Users

#### Generate icon and launch screens

Illustration by
<a style="background-color:black;color:white;text-decoration:none;padding:4px 6px;font-family:-apple-system, BlinkMacSystemFont, &quot;San Francisco&quot;, &quot;Helvetica Neue&quot;, Helvetica, Ubuntu, Roboto, Noto, &quot;Segoe UI&quot;, Arial, sans-serif;font-size:12px;font-weight:bold;line-height:1.2;display:inline-block;border-radius:3px;" href="https://unsplash.com/@neonbrand?utm_medium=referral&amp;utm_campaign=photographer-credit&amp;utm_content=creditBadge" target="_blank" rel="noopener noreferrer" title="Download free do whatever you want high-resolution photos from NeONBRAND"><span style="display:inline-block;padding:2px 3px;"><svg xmlns="http://www.w3.org/2000/svg" style="height:12px;width:auto;position:relative;vertical-align:middle;top:-1px;fill:white;" viewBox="0 0 32 32"><title></title><path d="M20.8 18.1c0 2.7-2.2 4.8-4.8 4.8s-4.8-2.1-4.8-4.8c0-2.7 2.2-4.8 4.8-4.8 2.7.1 4.8 2.2 4.8 4.8zm11.2-7.4v14.9c0 2.3-1.9 4.3-4.3 4.3h-23.4c-2.4 0-4.3-1.9-4.3-4.3v-15c0-2.3 1.9-4.3 4.3-4.3h3.7l.8-2.3c.4-1.1 1.7-2 2.9-2h8.6c1.2 0 2.5.9 2.9 2l.8 2.4h3.7c2.4 0 4.3 1.9 4.3 4.3zm-8.6 7.5c0-4.1-3.3-7.5-7.5-7.5-4.1 0-7.5 3.4-7.5 7.5s3.3 7.5 7.5 7.5c4.2-.1 7.5-3.4 7.5-7.5z"></path></svg></span><span style="display:inline-block;padding:2px 3px;">NeONBRAND</span></a>

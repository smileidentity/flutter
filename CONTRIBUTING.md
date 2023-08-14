## Overview

This repo encompasses everything necessary for the Smile ID Flutter SDK. It is a multi-module
project consisting of the following modules:

- [`smileid`](https://github.com/smileidentity/flutter/tree/main) -
  The SDK distributed to partners
- [`sample`](https://github.com/smileidentity/flutter/tree/main/sample) - a sample app
  that demonstrates SDK integration and showcases Smile ID products

## Setup

- [FVM](https://fvm.app/docs/getting_started/installation)  
- Android Studio or Visual Studio Code
- To generate new mocks, run `fvm flutter pub run build_runner build`
- [Cocoapods](https://cocoapods.org/)

## Run the sample app

We bundle a sample app that demonstrates SDK integration and showcases Smile ID products. To run itt, 
follow the following steps

#### Android
 
Open the `sample` folder, then open the `android` folder. Run the following commands

- Run `flutter pub get`
- Open the `android` folder in Android Studio

#### iOS

Open the `sample` folder, then open the `ios` folder. Run the following commands

- Run `flutter pub get`
- Run `pod install`
- Open `Runner.xcworkspace` in Xcode

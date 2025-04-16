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

We bundle a sample app that demonstrates SDK integration and showcases Smile ID products. To run it, 
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

# Testing unreleased Native SDKs

> ⚠️ **CAUTION:** We should never have unreleased SDKs in the main branch. This is only for testing unreleased SDKs. all PRs to main branch should be released SDKs.

## Android
* Uncomment  `maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }` in `android/build.gradle`
* Specify snapshot version in `android/build.gradle` file: which must have been prebuilt from any of the PRs in the [Android](https://github.com/smileidentity/android) repo

## iOS
* Comment out the version in the SmileID version for the native dependency in the  podspec file in `./ios/smile-id.podspec` file:
```ruby
#  s.dependency "SmileID" # => Mind the version removal
```
* Specify the repo SmileID [iOS](https://github.com/smileidentity/ios) repo and pick a tag or branch podspec file in the Podfile example/ios/Podfile file:
```ruby
  pod 'SmileID', git: 'https://github.com/smileidentity/ios.git', branch: 'main'
```
* Run `pod install` in the `example/ios` folder
* If you have pod install issues run
```bash
  pod deintegrate && pod install
```

Happy testing!

# Smile ID Flutter SDK

<p align="center">
<a href="https://apps.apple.com/us/app/smile-id/id6448359701?itscg=30200&amp;itsct=apps_box_appicon" style="width: 170px; height: 170px; border-radius: 22%; overflow: hidden; display: inline-block; vertical-align: middle;"><img src="https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/30/4a/94/304a94c9-239c-e460-c7e0-702cc8945827/AppIcon-1x_U007emarketing-0-10-0-85-220-0.png/540x540bb.jpg" alt="Smile ID" style="width: 170px; height: 170px; border-radius: 22%; overflow: hidden; display: inline-block; vertical-align: middle;"></a>
</p>

[![pub package](https://img.shields.io/pub/v/smile_id.svg)](https://pub.dev/packages/smile_id)
[![Build](https://github.com/smileidentity/flutter/actions/workflows/build.yaml/badge.svg)](https://github.com/smileidentity/flutter/actions/workflows/build.yaml)

Smile ID provides the best solutions for Real Time Digital KYC, Identity Verification, User
Onboarding, and User Authentication across Africa.

If you haven’t already,
[sign up](https://www.usesmileid.com/schedule-a-demo/) for a free Smile ID account, which comes
with Sandbox access.

Please see [CHANGELOG.md](CHANGELOG.md) or
[Releases](https://github.com/smileidentity/android/releases) for the most recent version and
release notes

<a href='https://play.google.com/store/apps/details?id=com.smileidentity.sample&utm_source=github&utm_campaign=flutter&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img width="250" alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>

<a href="https://apps.apple.com/us/app/smile-id/id6448359701?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1710028800" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>

## Getting Started

Full documentation is available at https://docs.usesmileid.com/integration-options/mobile

#### 0. Requirements

* Flutter 3.0.0+
* Dart 3.0.5+
* A `smile_config.json` file from [https://portal.usesmileid.com/sdk](https://portal.usesmileid.com/sdk)
* See: https://github.com/smileidentity/android for Android specific requirements
* See: https://github.com/smileidentity/ios for iOS specific requirements

#### 1. Dependency


The latest release is available on [pub.dev](https://pub.dev/packages/smile_id)

Add the dependency to your `pubspec.yaml`

```yaml
dependencies:
  smile_id: <latest-version>
```

#### 2. Smile Config

#### Android

Place the `smile_config.json` file under your application's assets, located at `src/main/assets` 
(This should be at the same level as your `java` and `res` directories). You may need to create the
directory if it does not already exist.

#### iOS

Drag the `smile_config.json` into your project's file inspector and ensure that the file is added to
your app's target. Confirm that it is by checking the Copy Bundle Resources drop down in the Build
Phases tab as shown below.

#### 3. Initialization

Initialize the Smile ID SDK in `main.dart` by calling `initialize`

```dart
import 'package:smile_id/smile_id.dart';
void main()  {
  SmileID.initialize();
}
```

## Getting Help

For detailed documentation, please visit https://docs.usesmileid.com/integration-options/mobile

If you require further assistance, you can
[file a support ticket](https://portal.usesmileid.com/partner/support/tickets) or
[contact us](https://www.usesmileid.com/contact-us/)

## Contributing

Bug reports and Pull Requests are welcomed. Please see [CONTRIBUTING.md](CONTRIBUTING.md)

## License

[MIT License](LICENSE)

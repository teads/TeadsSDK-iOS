# Teads - iOS AdMob Mediation Adapter

> Mediation adapter to be used in conjunction with AdMob to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AdMob mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 14+](https://img.shields.io/badge/Platform-iOS%2014%2B-blue.svg?style=flat)
- ![Xcode: 14+](https://img.shields.io/badge/Xcode-14+-blue.svg?style=flat)
- ![GoogleMobileAdsSDK: 11.2.0+](https://img.shields.io/badge/GoogleMobileAdsSDK-8.0+-blue.svg?style=flat)
- ![Teads SDK: 5.1.1+](https://img.shields.io/badge/Teads%20SDK-5.1.1+-blue.svg?style=flat)

## Features

- ✅ Displaying Teads banners
- ✅ Displaying Teads native ads

## Installation

Before installing Teads adapter, you need to implement [Google Mobile Ads](https://developers.google.com/admob/ios/quick-start) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `TeadsAdMobAdapter` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'TeadsAdMobAdapter', '~> 5.1'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation#defining_a_custom_event) step to finish the integration.
4. You’re done.

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation).

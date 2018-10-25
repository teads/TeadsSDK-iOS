# Teads - iOS AdMob Mediation Adapter
> Mediation adapter to be used in conjunction with AdMob to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AdMob mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 9+](https://img.shields.io/badge/Platform-iOS%209%2B-blue.svg?style=flat)
- ![Xcode: 9.0+](https://img.shields.io/badge/Xcode-9.0+-blue.svg?style=flat)
- ![GoogleMobileAdsSDK: 7.31.0+](https://img.shields.io/badge/GoogleMobileAdsSDK-7.31.0+-blue.svg?style=flat)
- ![Teads SDK: 4.0.7+](https://img.shields.io/badge/Teads%20SDK-4.0.7+-blue.svg?style=flat)

## Features

- [x] Displaying Teads interstitials
- [x] Displaying Teads rewarded ads
- [x] Displaying Teads banners

## Installation

Before installing Teads adapter, you need to implement [Google Mobile Ads](https://developers.google.com/admob/ios/quick-start) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `GoogleMobileAdsMediationTeads` in your Podfile:

```ruby
platform :ios, '9.0'
pod 'GoogleMobileAdsMediationTeads'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](#define-custom-event) step to finish the integration.
4. You’re done.

#### Manually

1. Integrate latest version of Teads SDK to your project using this [Quick Start Guide](http://mobile.teads.tv/sdk/documentation/v4/ios/get-started).
2. Download latest release of [`TeadsAdMobAdapter`](https://github.com/teads/TeadsSDK-iOS/releases).
3. Drop adapter files in your iOS project.
4. Follow the [Define Custom Event](#define-custom-event) step to finish the integration.
5. You’re done.

## Documentation

### Define Custom Event

In order to display a Teads ad through AdMob mediation, you need to create a [custom event](https://support.google.com/admob/answer/3083407) on [AdMob dashboard](https://www.google.com/admob/).

When creating a custom event, you are required to define these informations:

| Name | Description |
|------------|---------------------------------------------|
| `Class Name` | Class name of the adapter |
| `Parameter`  | Teads placement ID (PID)                                       |

1. For `Class Name` parameter, you need to use one of these names depending on ad type:

 - Banner ad: `GADMAdapterTeadsBanner`
 - Interstitial ad: `GADMAdapterTeadsInterstitial`
 - Rewarded ad: `GADMAdapterTeadsRewardedVideo`

2. For the `Parameter`, you need to use your Teads placement ID (PID).

**Important note #1:** Depending on your integration method, you need to prefix `Class Name` like this:

- if you're using our Objective-C framework or standalone class files:
  - Banner ad: `GADMAdapterTeadsBanner`
  - Interstitial ad: `GADMAdapterTeadsInterstitial`
  - Rewarded ad: `GADMAdapterTeadsRewardedVideo`

- if you're using our Swift framework:
  - Banner ad: `TeadsAdMobAdapter.GADMAdapterTeadsBanner`
  - Interstitial ad: `TeadsAdMobAdapter.GADMAdapterTeadsInterstitial`
  - Rewarded ad: `TeadsAdMobAdapter.GADMAdapterTeadsRewardedVideo`

- if you're using our Swift standalone class files:
  - Banner ad: `__module_name__.GADMAdapterTeadsBanner`
  - Interstitial ad: `__module_name__.GADMAdapterTeadsInterstitial`
  - Rewarded ad: `__module_name__.GADMAdapterTeadsRewardedVideo`

Where you need to replace `__module_name__` by the name of your app/framework module in which you integrate the adapter:
- `appName`
- `appName_targetName` (if you have multiple targets in your project or if the project name is different from the target name) 

Remember to replace any non-alphanumeric characters such as dashes with underscores.

**Example #1:** If you add a Teads interstitial placement in AdMob and you integrate the adapter through our Swift class files in a Swift app named `Demo`, you'll use `Demo.GADMAdapterTeadsInterstitial` for `Class Name`.

**Example #2:** If you add a Teads rewarded ad placement in AdMob and you integrate the adapter through our Swift framework in a Swift app named `Demo`, you'll use `TeadsAdMobAdapter.GADMAdapterTeadsRewardedVideo` for `Class Name`.

**Example #3:** If you add a Teads banner placement in AdMob and you integrate the adapter through our ObjC class files in an ObjC app named `Demo`, you'll use `GADMAdapterTeadsBanner` for `Class Name`.

### Mediation Settings

For AdMob integration, you have the ability to pass extra parameters in order to customize third-party ad networks settings.
For Teads, you need to use `GADMAdapterTeadsExtras` class to pass extra parameters.

1. Create an instance of `GADMAdapterTeadsExtras`.
2. Populate it with your custom settings.
3. Register it into `GADRequest` using [`registerAdNetworkExtras:`](https://developers.google.com/admob/ios/api/reference/Classes/GADRequest#-registeradnetworkextras) method.
4. Teads rewarded ad will receive your specific custom settings when it will load.

The code integration is slightly different depending on ad type:

- For rewarded ad:

```swift
// Create request
let request = GADRequest()

// Create extra parameters for Teads rewarded ad
let extras = GADMAdapterTeadsExtras()
extras.debugMode = true
request.register(extras)
```

- For banner or interstitial ad:

```swift
// Create request
let request = GADRequest()

// Create extra parameters for Teads interstitial ad
let extras = GADMAdapterTeadsExtras()
extras.debugMode = true
request.register(extras.getCustomEventExtras(forCustomEventLabel: "__custom_event_label__"))
```

**Important note:** You need to replace `__custom_event_label__` by the name defined in [AdMob dashboard](https://www.google.com/admob/) for `Custom Event Label` parameter. It is the name of your custom event.

Here is a list of available extra parameters:

| Settings                                                  | Description                                                                                                                                             |
|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `public var debugMode`                                           | Enable/disable debug logs from Teads SDK.                                                                                                                       |
| `public var reportLocation`                               | Enable/disable collection of user location. By default, SDK will collect user location if corresponding permissions has been granted to the host application. |
| `public var mediaPreloadEnabled`                                   | Enable/disable preload of media files (like videos). If disabled, media files will be loaded lazily.                                                          |
| `public var pageUrl`                                  | Sets the publisher page url where ad will be loaded into (for brand safety purposes).                                                                   |
| `public var lightEndscreenMode`                                     | Enable/disable light mode for the ad end screen. By default, dark mode is used.                                                                                    |

## Changelog

See [CHANGELOG](CHANGELOG.md). 

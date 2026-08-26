# Teads - iOS AdMob Mediation Adapter

> Mediation adapter to be used in conjunction with AdMob to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AdMob mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![GoogleMobileAdsSDK: 8.0+](https://img.shields.io/badge/GoogleMobileAdsSDK-8.0+-blue.svg?style=flat)
- ![Teads SDK: 5.0.3+](https://img.shields.io/badge/Teads%20SDK-5.0.3+-blue.svg?style=flat)

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

#### Swift Package Manager

1. Add the package `https://github.com/teads/TeadsSDK-iOS` and link both the `TeadsSDK`
   and `TeadsAdMobAdapter` products.
2. Add the Google Mobile Ads SDK to your project yourself — the adapter does **not** bundle
   it. Use `https://github.com/googleads/swift-package-manager-google-mobile-ads.git`.
3. Call `TeadsAdMobMediation.register()` once at startup. See below.
4. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation#defining_a_custom_event) step to finish the integration.

### ⚠️ Call `TeadsAdMobMediation.register()`

The adapter ships as a static framework, and its custom-event classes
(`GADMAdapterTeadsBanner`, `GADMAdapterTeadsNative`, `GADMAdapterTeadsInterstitial`) are
instantiated **by name** by the Google Mobile Ads SDK from your AdMob dashboard
configuration. Because nothing in your own code references them, the linker strips them —
and then the app builds, launches and runs normally while Teads never serves.

Referencing them once from your app prevents that. Call it before
`MobileAds.shared.start(completionHandler:)` or your first ad request:

```swift
import TeadsAdMobAdapter

TeadsAdMobMediation.register()
MobileAds.shared.start()
```

It is safe to call unconditionally, on any integration method.

#### Alternative: the `-ObjC` linker flag

Adding `-ObjC` to **Other Linker Flags** on your application target has the same effect,
by force-loading every Objective-C class instead of just these three. CocoaPods
integrations get `-ObjC` automatically from the Google Mobile Ads podspec, which is why
this step has historically not been needed there. Swift Package Manager cannot apply it on
your behalf, so `register()` is the recommended route.

#### Diagnosing a stripped build

There is no crash and no error — the symptom is zero Teads fill through mediation. The
Google Mobile Ads SDK does log it, so search your console for:

```
Cannot find Custom Event class named GADMAdapterTeadsBanner.
```

You can also assert it yourself. Dead-stripping only happens in optimised builds, so check
in a **Release** build, and use a plain runtime check rather than `assert` (which the
compiler removes under `-O`, i.e. exactly where the problem appears):

```swift
if NSClassFromString("TeadsAdMobAdapter.GADMAdapterTeadsBanner") == nil {
    print("[Teads] AdMob adapter classes were stripped — call TeadsAdMobMediation.register().")
}
```

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation).

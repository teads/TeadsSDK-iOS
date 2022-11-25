# Teads - iOS AdMob Mediation Adapter
> Mediation adapter to be used in conjunction with AdMob to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AdMob mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![GoogleMobileAdsSDK: 9.0+](https://img.shields.io/badge/GoogleMobileAdsSDK-9.0+-blue.svg?style=flat)
- ![Teads SDK: 5.0.3+](https://img.shields.io/badge/Teads%20SDK-5.0.3+-blue.svg?style=flat)

## Features

- ✅  Displaying Teads banners
- ✅  Displaying Teads native ads

## Installation

Before installing Teads adapter, you need to implement [Google Mobile Ads](https://developers.google.com/admob/ios/quick-start) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `TeadsAdMobAdapter` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'TeadsAdMobAdapter', '~> 5.0'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation#defining_a_custom_event) step to finish the integration.
4. You’re done.

### Swift Package Manager

[SPM](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

#### Installing from Xcode

1. Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.
2. Search for the Teads iOS SDK using the repo's URL:
```console
https://github.com/teads/TeadsSDK-iOS
```
3. Next, set the **Dependency Rule** to be `Up to Next Major Version` and keep `5.0.0 < 6.0.0`.
4. Choose the Teads product that you want to be installed in your app: `TeadsAdMobAdapter`
5. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation#defining_a_custom_event) step to finish the integration.

#### Alternatively, add Teads to your Package.swift manifest
1. Add it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/teads/TeadsSDK-iOS", .upToNextMajor(from: "5.0.0"))
]
```

2. in any target that depends on a Teads product, add it to the `dependencies` array of that target:

```swift
.target(
  name: "MyTargetName",
  dependencies: [
    .product(name: "TeadsAdMobAdapter", package: "Teads"),
  ]
),
```

3. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation#defining_a_custom_event) step to finish the integration.

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000314767-inread-google-ad-manager-and-admob-mediation).
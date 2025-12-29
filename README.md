# Teads SDK for iOS

<p align="center">
    <a href="https://teads.com/" target="_blank">
        <img width="75%" src="https://raw.githubusercontent.com/teads/TeadsSDK-iOS/master/ReadmeResources/teads_logo.png" alt="Teads logo">
    </a>
</p>

----

Teads SDK provides seamless access to both premium video advertising and content recommendation capabilities through a modern, unified interface. This sample app includes Teads iOS framework and demonstrates integration examples for Media Placements (video ads), Native Ads, and Feed Placements (content recommendations).

## 📋 Table of Contents

- [Integration Documentation](#-integration-documentation)
- [Migrating to v6](#-migrating-to-v6)
- [Run the sample app](#-run-the-sample-app)
- [Installation](#-install-the-teads-sdk-ios-framework)
- [Mediation Adapters](#-mediation-adapters)
- [Certifications](#-certifications)
- [Changelog](#%EF%B8%8F-changelog)

## 📚 Integration Documentation

- Integration instructions are available on [Teads Developer Portal](https://developers.teads.com/docs/iOS-SDK/Getting-Started/).
- Installation guide is available [here](https://developers.teads.com/docs/iOS-SDK/Getting-Started/installation).
- Full integration guide is available [here](https://developers.teads.com/docs/iOS-SDK/Getting-Started/integration-guide).

## 🕊 Migrating to v6

TeadsSDK v6 introduces a new unified `createPlacement` API. See [Migration Documentation](https://developers.teads.com/docs/iOS-SDK/Getting-Started/migration-teads) for details.

## 🚲 Run the sample app

Clone this repository, open it with Xcode, and run project.

## 📦 Install the Teads SDK iOS framework

### Cocoapods

To install the TeadsSDK just put this on your podfile, if you've never used cocoapods before please check the [offical documentation](https://guides.cocoapods.org/using/using-cocoapods.html).

```ruby
pod 'TeadsSDK', '~> 6.0.5'
```

On your terminal, go to the directory containing your project's `.xcodeproj` file and your Podfile and run `pod install` command. This will install Teads SDK along with our needed dependencies.

```console
pod install --repo-update
```

Before installing Teads adapter, you need to implement [Google Mobile Ads](https://developers.google.com/admob/ios/quick-start) in your application.

### Swift Package Manager

[SPM](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

#### Installing from Xcode

1. Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.
2. Search for the Teads iOS SDK using the repo's URL:
```console
https://github.com/teads/TeadsSDK-iOS
```
3. Next, set the **Dependency Rule** to be `Up to Next Major Version` and keep `6.0.0 < 7.0.0`.
4. Choose the Teads product that you want to be installed in your app: `TeadsSDK`

#### Alternatively, add Teads to your Package.swift manifest
1. Add it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/teads/TeadsSDK-iOS", .upToNextMajor(from: "6.0.0"))
]
```

2. in any target that depends on a Teads product, add it to the `dependencies` array of that target:

```swift
.target(
  name: "MyTargetName",
  dependencies: [
    // The product(s) you want (e.g. TeadsSDK).
    .product(name: "TeadsSDK", package: "Teads"),
  ]
),
```

## 🤝 Mediation Adapters
- [Google AdMob](./MediationAdapters/TeadsAdMobAdapter/README.md)
- [AppLovin Max](./MediationAdapters/TeadsAppLovinAdapter/README.md)
- [Smart AdServer](./MediationAdapters/TeadsSASAdapter/README.md)

## 🎓 Certifications

Teads SDK supports the [IAB](https://www.iabcertification.com/) [Open Measurement](https://iabtechlab.com/standards/open-measurement-sdk/) SDK, also known as OM SDK. The OM SDK brings transparency to the advertising world, giving a way to standardize the viewability and verification measurement for the ads served through mobile apps.  Teads is part of the [IAB's compliant companies](https://iabtechlab.com/compliance-programs/compliant-companies/). 

![iab certification badge](https://raw.githubusercontent.com/teads/TeadsSDK-iOS/master/ReadmeResources/OMCompliant.png)


## ⌚️ Changelog

See [changelog here](https://github.com/teads/TeadsSDK-iOS/releases) or check the [Release Notes](https://developers.teads.com/docs/iOS-SDK/Getting-Started/release-notes).

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
- [SwiftUI sample app](#-swiftui-sample-app)
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

Both sample apps use **Swift Package Manager** — no `pod install` step is needed.

1. Clone this repository.
2. Open `TeadsSampleApp.xcodeproj` and let Xcode resolve the packages (`File` → `Packages` → `Resolve Package Versions` if it does not start automatically).
3. Select the **`TeadsSampleApp`** scheme and run.

There is no Xcode workspace: each sample app is a standalone project that you open directly.

The sample apps resolve the following packages:

| Package | Version | Provides |
| ------- | ------- | -------- |
| `SampleApps/TeadsSampleAppDependencies` (local) | — | `TeadsSDK`, `TeadsAdMobAdapter` and `TeadsAppLovinAdapter` (the xcframeworks of `Frameworks/`) and `TeadsSASAdapter`, built from the `MediationAdapters/TeadsSASAdapter` sources |
| [swift-package-manager-google-mobile-ads](https://github.com/googleads/swift-package-manager-google-mobile-ads) | `12.12.0 ..< 13.0.0` | `GoogleMobileAds` |
| [AppLovin-MAX-Swift-Package](https://github.com/AppLovin/AppLovin-MAX-Swift-Package) | `13.4.0 ..< 14.0.0` | `AppLovinSDK` |
| [swift-package-manager-display-sdk](https://github.com/smartadserver/swift-package-manager-display-sdk) | `7.24.2 ..< 8.0.0` | `SASDisplayKit` |

Both app targets declare the exact same package requirements, and the exact versions they were validated against are committed in each project's `project.xcworkspace/xcshareddata/swiftpm/Package.resolved`. Keep the two lockfiles in sync when you bump a dependency: since the projects resolve independently, a divergence there is not reported as a conflict.

> The prebuilt `TeadsAdMobAdapter.xcframework` still exposes `GADCustomEventExtras`, which the Google Mobile Ads SDK removed in 13.0.0, hence the `12.x` requirement.

Code formatting is checked by a `SwiftFormat` build phase: it runs `swiftformat --lint` when SwiftFormat is installed locally (`brew install swiftformat`) and is skipped otherwise. Run `swiftformat .` from the repository root to apply the fixes.

## 📱 SwiftUI sample app

Alongside the UIKit `TeadsSampleApp`, this repository ships a SwiftUI sample, **`TeadsSwiftUISampleApp`**, demonstrating Teads integration in SwiftUI-first apps. Both apps are standalone Xcode projects consuming the same Swift packages.

1. Open `TeadsSwiftUISampleApp.xcodeproj`.
2. Select the **`TeadsSwiftUISampleApp`** scheme and run on an iOS 16+ simulator.

### Coverage

The SwiftUI sample mirrors the UIKit `TeadsSampleApp` parity matrix and uses the same public test PIDs:

| Format       | Provider                  | Containers                                                                            |
| ------------ | ------------------------- | ------------------------------------------------------------------------------------- |
| InRead       | Direct                    | `ScrollView`, `List`, `LazyVGrid`, paginated `TabView`, `WKWebView` via `UIViewRepresentable` |
| InRead       | AdMob, AppLovin, SAS      | `ScrollView`, `List`, `WKWebView` (where the provider supports the integration)       |
| Native       | Direct                    | `List`, `LazyVStack`, tag-based `List`                                                 |
| Native       | AdMob, AppLovin, SAS      | `List`                                                                                |
| Interstitial | AdMob                     | Article paywall + interstitial presentation                                            |
| Showcase     | Direct                    | Media (video) + Feed (content recommendations) in a single article                     |

The root catalogue (`RootCatalogView`) mirrors the UIKit `RootController` selection flow: Format → Provider → Creative → Integration, plus a Validation Mode toggle and a custom-PID alert.

### Direct InRead — official SwiftUI API

The Direct InRead samples use the official SwiftUI API shipped by the SDK:

```swift
import SwiftUI
import TeadsSDK

struct ContentView: View {
    private let config = TeadsAdPlacementMediaConfig(pid: 84242, articleUrl: URL(string: "https://www.teads.com"))

    var body: some View {
        ScrollView {
            // ...article content...
            TeadsAdPlacementSwiftUIView<TeadsAdPlacementMedia>(config: config)
        }
    }
}
```

You can also use the `.teadsAdPlacement(config:delegate:)` view modifier, which stacks the ad below the modified content. For readability, the sample app aliases the generic view as `TeadsMediaSwiftUIView` (= `TeadsAdPlacementSwiftUIView<TeadsAdPlacementMedia>`) and `TeadsFeedSwiftUIView` for the Feed equivalent.

### Mediation, Native and Interstitial — `UIViewRepresentable`

Mediation (AdMob, AppLovin, SAS), Native ads (any provider, including Teads Direct via `TeadsAdPlacementMediaNative`/`TeadsNativeAdView`) and the AdMob Interstitial flow render UIKit views. The sample bridges them into SwiftUI with focused `UIViewRepresentable` / `UIViewControllerRepresentable` wrappers (`AdMobBannerHost`, `AppLovinBannerHost`, `SASBannerHost`, `TeadsNativeAdHost`, etc.) — the same pattern publishers will use when embedding mediated ads in a SwiftUI screen.

## 📦 Install the Teads SDK iOS framework

### Cocoapods

CocoaPods remains a supported distribution channel: the podspecs at the root of this repository (`TeadsSDK.podspec` and the adapter ones) are the ones published to the trunk. Only the sample apps of this repository switched to Swift Package Manager.

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

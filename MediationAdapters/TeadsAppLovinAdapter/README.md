# Teads - iOS AppLovin MAX Mediation Adapter
> Mediation adapter to be used in conjunction with AppLovin to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AppLovin MAX mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![AppLovin SDK: 11.5.1+](https://img.shields.io/badge/AppLovin%20SDK-11.5.1+-blue.svg?style=flat)
- ![Teads SDK: 5.0.12+](https://img.shields.io/badge/Teads%20SDK-5.0.12+-blue.svg?style=flat)

## Features

- ✅  Displaying Teads inRead ads
- ✅  Displaying Teads native ads

## Installation

Before installing Teads adapter, you need to implement [AppLovin Ads](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `TeadsAppLovinAdapter` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'TeadsAppLovinAdapter', '~> 5.0'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Create a custom Network](https://support.teads.tv/support/solutions/articles/36000357700-inread-applovin-mediation#create-a-custom-network) step to finish the integration.
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
4. Choose the Teads product that you want to be installed in your app: `TeadsAppLovinAdapter`
5. Follow the [Create a custom Network](https://support.teads.tv/support/solutions/articles/36000357700-inread-applovin-mediation#create-a-custom-network) step to finish the integration.

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
    .product(name: "TeadsAppLovinAdapter", package: "Teads"),
  ]
),
```

3. Follow the [Create a custom Network](https://support.teads.tv/support/solutions/articles/36000357700-inread-applovin-mediation#create-a-custom-network) step to finish the integration.


## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000357700-inread-applovin-mediation).

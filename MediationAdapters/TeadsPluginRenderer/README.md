# Teads - iOS Prebid Plugin Renderer

> Mediation adapter to be used in conjunction with Prebid to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through Prebid SDK mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![Prebid SDK: 3.0.2+](https://img.shields.io/badge/PrebidMobile-3.0.2+-blue.svg?style=flat)
- ![Teads SDK: 5.4.0+](https://img.shields.io/badge/Teads%20SDK-5.4.0+-blue.svg?style=flat)

## Features

- ✅ Displaying Teads inRead ads

## Installation

Before installing Teads adapter, you need to implement [Prebid](https://docs.prebid.org/prebid-mobile/pbm-api/ios/code-integration-ios.html) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `TeadsPluginRenderer` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'TeadsPluginRenderer', '~> 5.1'
```

2. Run `pod install --repo-update` to install the adapter in your project.step to finish the integration.
3. You’re done.
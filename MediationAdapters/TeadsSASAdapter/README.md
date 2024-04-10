# Teads - iOS Smart AdServer Mediation Adapter

> Mediation adapter to be used in conjunction with Smart Ads Server to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through Smart Ads Server mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![SAS SDK: 7.62+](https://img.shields.io/badge/Smart%20AdServer%20SDK-7.62+-blue.svg?style=flat)
- ![Teads SDK: 5.0.3+](https://img.shields.io/badge/Teads%20SDK-5.0.3+-blue.svg?style=flat)

## Features

- ✅ Displaying Teads banners

## Installation

Before installing Teads adapter, you need to implement [Smart Ads Server ](https://documentation.smartadserver.com/displaySDK/ios/gettingstarted.html) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `TeadsSASAdapter` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'TeadsSASAdapter', '~> 5.1'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314771-smart-adserver-mediation#defining_a_custom_event) step to finish the integration.
4. You’re done.

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000314771-smart-adserver-mediation).

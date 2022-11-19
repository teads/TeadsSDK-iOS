# Teads - iOS AppLovin MAX Mediation Adapter
> Mediation adapter to be used in conjunction with AppLovin to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AppLovin MAX mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![AppLovin SDK: 11.1.1+](https://img.shields.io/badge/AppLovin%20SDK-11.1.1+-blue.svg?style=flat)
- ![Teads SDK: 5.0.20+](https://img.shields.io/badge/Teads%20SDK-5.0.12+-blue.svg?style=flat)

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


## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000357700-inread-applovin-mediation).

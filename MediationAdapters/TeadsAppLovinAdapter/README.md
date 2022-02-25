# Teads - iOS AppLovin MAX Mediation Adapter
> Mediation adapter to be used in conjunction with AppLovin to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through AppLovin mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 12.5+](https://img.shields.io/badge/Xcode-12.5+-blue.svg?style=flat)
- ![AppLovin SDK: 11.1.2+](https://img.shields.io/badge/MoPub%20SDK-11.1.2+-blue.svg?style=flat)
- ![Teads SDK: 5.0.9+](https://img.shields.io/badge/Teads%20SDK-5.0.9+-blue.svg?style=flat)

## Features

- ✅  Displaying Teads banners
- ✅  Displaying Teads native ads

## Installation

Before installing Teads adapter, you need to implement [AppLovin Ads](https://developers.mopub.com/docs/ios/) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `TeadsAppLovinAdapter` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'TeadsAppLovinAdapter', '~> 5.0'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000314769-inread-twitter-mopub-mediation#defining_a_custom_event) step to finish the integration.
4. You’re done.


## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000314769-inread-twitter-mopub-mediation).
# TeadsSDK-ios


Teads allows you to integrate a single SDK into your app, and serve premium branded "outstream" video ads from Teads SSP ad server. This sample app includes Teads iOS library and is showing integration examples.

## Run the sample app

Clone this repository, open it with Xcode, and run project.

## Install the Teads SDK iOS library

Teads SDK is currently distributed through CocoaPods. It include everything you need to serve "outstream" video ads.

### Cocoapods

```
target 'YourProject' do
    pod 'TeadsSDK', 'X.Y.Z'
end
```
Replace the X.Y.Z above with the [latest release version](https://github.com/teads/TeadsSDK-iOS/releases/latest).

In terminal in the directory containing your project's `.xcodeproj` file and the Podfile, run `pod install` command. This will install Teads SDK along with our needed dependencies.

```
$ pod install --repo-update
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate TeadsSDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "teads/TeadsSDK-iOS" "X.Y.Z"
```
Replace the X.Y.Z above with the [latest release version](https://github.com/teads/TeadsSDK-iOS/releases/latest).

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000165909).

## Known Issue

### Xcode 12 Excluded Architecture

[#142](https://github.com/teads/TeadsSDK-iOS/issues/142) Our third party viewability solution is unfortunately not yet compatible with ARM Simulator Architecture.

## Changelog

See [changelog here](CHANGELOG.md). 

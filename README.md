# TeadsSDK-ios


Teads allows you to integrate a single SDK into your app, and serve premium branded "outstream" video ads from Teads SSP ad server. This demo app includes Teads iOS library and is showing integration examples.

## Run the sample app

Clone this repository, open it with Xcode, and run project.

## Download the Teads SDK iOS library

Teads SDK is currently distributed through CocoaPods. It include everything you need to serve "outstream" video ads.

```
target 'YourProject' do
    pod 'TeadsSDK-v4-beta-xcode9.2', '4.0.5-beta'
end
```

In terminal in the directory containing your project's `.xcodeproj` file and the Podfile, run `pod install` command. This will install Teads SDK along with our needed dependencies.

```
$ pod install --repo-update
```

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](http://mobile.teads.tv/sdk/documentation/v4).
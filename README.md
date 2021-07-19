# TeadsSDK-ios


Teads allows you to integrate a single SDK into your app, and serve premium branded "outstream" video ads from Teads SSP ad server. This sample app includes Teads iOS framework and is showing integration examples.

### Requirements 

* Xcode >= 12.1 / Swift 5.3
* iOS  >= 10.0

### Run the sample app and discover how we integrate our SDK

The best way to see the working integration is to clone this repository, open it with Xcode, and run project. The sample contains multiples kind of integrations from direct integration to integrations using mediations partners such as AdMob, Mopub, Smart.

--

# Direct integration

*For setup through mediation partners check those [steps](#setup-for-mediations).*


## Install the Teads SDK iOS framework


Teads SDK is currently distributed through CocoaPods. It includes everything you need to serve "outstream" video ads.


### Cocoapods

```
target 'YourProject' do
    pod 'TeadsSDK', :git => 'https://github.com/teads/TeadsSDK-iOS.git', :branch => 'v5'
end
```

In terminal in the directory containing your project's `.xcodeproj` file and the Podfile, run `pod install` command. This will install Teads SDK along with our needed dependencies.

```
$ pod install
```


### Swift Package Manager (coming soon)

[SPM](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies. To integrate TeadsSDK into your Xcode project using SPM, specify package repository url:

```
https://github.com/teads/TeadsSDK-iOS
```

## Migration from v4 to v5

In the v5 of the SDK, we've introduced a new class called `TeadsInReadAdPlacement` which is responsible of configuring the ad request and then make it

### Rename your ad view 

For now on, we have replaced the old class `TFAInReadAdView` by a new one called `TeadsInReadAdView`. So you just need to rename it, in code and do not forget your storyboards if you are using it.

```swift
var teadsAdView: TeadsInReadAdView
```

### Remove old unused TFAInReadAdView properties

The new `TeadsInReadAdView` does not handle the ad request therefore it does not have a PID property and load method anymore.
You need to delete those lines of code: 

```swift
teadsAdView.pid = Int(pid) ?? 0
let teadsAdSettings = TeadsAdSettings(build: { (settings) in
   settings.enableDebug()
}
teadsAdView.load(teadsAdSettings: teadsAdSettings)
```

### Create an AdPlacement 

Keep a reference of the adPlacement by declarating it as a class variable.

```swift
var placement: TeadsInReadAdPlacement?
```


Initialize the adPlacement (for example in your `viewDidLoad`):

```swift
placement = Teads.createInReadPlacement(pid: <#YOUR_PID#>, delegate: self)
```

--
**(Optional)** Pass configurations to the adPlacement:

```swift
let pSettings = TeadsAdPlacementSettings { (settings) in
    settings.enableDebug()
}
placement = Teads.createInReadPlacement(pid: <#YOUR_PID#>, settings: pSettings, delegate: self)
```
--
### Request an Ad

You can then request an ad using the placement you have just created. Do not forget the adSettings with your article url (if applicable). To know more about TeadsAdRequestSettings parameters check [this](). 

```swift
let adSettings = TeadsAdRequestSettings(build: { (settings) in
   let articleUrlString = <#https://www.YOURWEBSITE.COM/YOUR_ARTICLE_ID#>
   settings.pageUrl(articleUrlString)
 })
placement?.requestAd(requestSettings: adSettings)
```

### Implement the new delegates

The old `TFAAdDelegate` has been replaced by two new delegates `TeadsInReadAdPlacementDelegate` and `TeadsAdDelegate`.

#### Implement the TeadsInReadAdPlacementDelegate

The TeadsInReadAdPlacementDelegate have 4 methods that you need to implement.

```swift
extension <#YOURViewController#>: TeadsInReadAdPlacementDelegate {
    
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        teadsAdView.bind(ad)
        ad.delegate = self
        //here you need to resize the height of your ad view in order to get the right aspect ratio for the creative
        <#your view height#> = adRatio.calculateHeight(for: view.frame.width)
    }

    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        //here you need to resize the height of your ad view in order to get the right aspect ratio for the creative
        <#your view height#> = adRatio.calculateHeight(for: view.frame.width)
    }
    
    func didFailToReceiveAd(reason: AdFailReason) {
        //here you should hide your ad view
        <#your view height#> = 0
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        <#your_ad_container_view#>.addSubview(trackerView)
    }
    
}
```

### Implement the TeadsAdDelegate

The TeadsAdDelegate have 5 methods that you need to implement.


```swift
extension <#YOURViewController#>: TeadsAdDelegate {
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return self
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        //here you should hide your ad view
        <#your view height#> = 0
    }
    
    func didCloseAd(ad: TeadsAd) {
        //here you should hide your ad view
        <#your view height#> = 0
    }

    func didRecordImpression(ad: TeadsAd) {
        
    }
    
    func didRecordClick(ad: TeadsAd) {
    
    }
    
}
```

You are all set! You can now display Teads ads inside your app. 🎉

# Setup for mediations

### Extra requirements for mopub
For mopub mediation integration Xcode 12.5 or upper is mandatory due to mopub release (https://github.com/mopub/mopub-ios-sdk/issues/390#issuecomment-843304858)



## Changelog

See [changelog here](CHANGELOG.md). 

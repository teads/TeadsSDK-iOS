# TeadsSDK-iOS


Teads allows you to integrate a single SDK into your app, and serve premium branded "outstream" video ads from Teads SSP ad server. This sample app includes Teads iOS framework and is showing integration examples.

### Requirements 

* Xcode >= 12.1 / Swift 5.3
* iOS  >= 10.0

### Run the sample app and discover how we integrate our SDK

The best way to see the working integration is to clone this repository, open it with Xcode, and run the project. The sample contains multiples kinds of integrations from direct integration to integrations using mediations partners such as AdMob, Mopub, Smart.


# Direct integration

*To setup through mediation partners check those [steps](#setup-for-mediations).*


## Install the Teads SDK iOS framework

Teads SDK is currently distributed through CocoaPods. It includes everything you need to serve "outstream" video ads. 

### Cocoapods

To install the TeadsSDK just put this on your podfile, if you've never used cocoapods before please check the [offical documentation](https://guides.cocoapods.org/using/using-cocoapods.html).

```ruby
pod 'TeadsSDK', '~> 5.0'
```

On your terminal, go to the directory containing your project's `.xcodeproj` file and your Podfile and run `pod install` command. This will install Teads SDK along with our needed dependencies.

```bash
pod install --repo-update
```

## Migrating from v4 to v5

In SDK's v5, we've introduced a new class called `TeadsInReadAdPlacement` which is responsible of configuring the ad request and then make the call.

### Rename your ad view 

We've replaced the old class `TFAInReadAdView` with a new one called `TeadsInReadAdView`. All you need to do is renaming it (don't forget your storyboard or nib files if needed).

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

Keep a reference of the adPlacement by declaring it as a class variable.

```swift
var placement: TeadsInReadAdPlacement?
```


Initialize the adPlacement (for example in your `viewDidLoad`):

```swift
placement = Teads.createInReadPlacement(pid: <#YOUR_PID#>, delegate: self)
```

--
**(Optional)** Add settings to the adPlacement initialization parameters, note this could be mandatory if your app have to manage the privacies consent, more details about [TeadsAdPlacementSettings](#teadsadplacementsettings).

```swift
let pSettings = TeadsAdPlacementSettings { (settings) in
    settings.enableDebug()
}
placement = Teads.createInReadPlacement(pid: <#YOUR_PID#>, settings: pSettings, delegate: self)
```

For more information about the user privacies consent, see this [documentation] (https://support.teads.tv/support/solutions/articles/36000166727-privacy-consent-management-gdpr-ccpa-).

--
### Request an Ad

You can then request an ad using the placement you've just created. Do not forget to provide your article url (if applicable) through `TeadsAdRequestSettings`. To know more about `TeadsAdRequestSettings` parameters check [this](#teadsadrequestsettings). 

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

The TeadsInReadAdPlacementDelegate owns 4 methods that you need to implement. This delegate is reacting to the ad loading process, for example to let the app know when an ad is received or when the ad server failed to deliver one.

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
        <#your_ad_container_view#>.addSubview(trackerView)  // See TeadsAdOpportunityTrackerView documentation for more information
    }
    
}
```

#### TeadsAdOpportunityTrackerView

The `TeadsAdOpportunityTrackerView` is a view that you will need to add to your slot view *(e.g. the view where you will display the ad)*. 
This view will be provided during the ad request process and will allow Teads to monitor with precision ad opportunities on [**Teads for Publisher**](https://publishers.teads.tv/).

You should add it where the ad will be displayed, even if you didn't have received an ad from our SDK.
This view needs to be at the origin of your ad slot `(x:0, y:0)`.

Once the `TeadsAdOpportunityTrackerView` is visible, it will be automatically removed by the SDK. 

```swift
func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
    slotView.addSubview(trackerView)
}
```

**Note: if you don't use your own ad slot you can add it directly to your teadsAdView.**


### Implement the TeadsAdDelegate

The TeadsAdDelegate own 5 methods that you need to implement. This delegate is reacting to the ad lifecycle (e.g. impressions, clicks, ad close, modal presentation...). 

```swift
extension <#YOURViewController#>: TeadsAdDelegate {
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return self
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        //here you should hide your ad view
        <#your view height#> = 0
    }
    
    func didClose(ad: TeadsAd) {
        //here you should hide your ad view
        <#your view height#> = 0
    }

    func didRecordImpression(ad: TeadsAd) {
        //you may want to use this callback for your own analytics
    }
    
    func didRecordClick(ad: TeadsAd) {
       //you may want to use this callback for your own analytics
    }
    
    func didExpandedToFullscreen(ad: TeadsAd) {
       //you may want to use this callback for your own analytics
    }
    
    func didCollapsedFromFullscreen(ad: TeadsAd) {
       //you may want to use this callback for your own analytics
    }
    
}
```

Note: didRecordImpression and didRecordClick are provided for your analytics if you have some, otherwise it could be empty.

You are all set! You can now display insane Teads ads inside your app. 🎉

### Validate your integration

In order to be sure that your integration is well done you can use our validation tool.

To do that you just have to enable it in the `TeadsAdRequestSettings` like that:

```swift
let adSettings = TeadsAdRequestSettings(build: { (settings) in
   let articleUrlString = <#https://www.YOURWEBSITE.COM/YOUR_ARTICLE_ID#>
   settings.pageUrl(articleUrlString)
   settings.enableValidationMode()
 })
placement?.requestAd(requestSettings: adSettings)
```

Compile, then go to the controller that contains your ad and you just have to follow along with the instructions.

**Note: ⚠️ don't forget to remove this setting before going in production!**

## TeadsAdRequestSettings 

When you request an ad with the adPlacement you can pass customs settings.

* `enableValidationMode()`, this is the best way to ensure all basic features and prerequisites are correctly implemented. It is also useful during integration iterations.

* `pageUrl(String)` Setting up the page url, to tell the SDK in which content the ad will be shown.

## TeadsAdPlacementSettings

* `disableCrashMonitoring()`, disallows the SDK to send crash logs to our servers.
* `disableBatteryMonitoring()`, disallows the SDK to add battery informations to our logs.
* `disableTeadsAudioSessionManagement()`, if you have custom sound session management you need to disable our audio session management and implement the TeadsSoundDelegate. 
{"mode":"full","isActive":false}

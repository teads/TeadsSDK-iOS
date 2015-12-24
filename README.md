# Teads iOS SDK

[![Build Status](https://jenkins.teads.net/buildStatus/icon?job=TeadsSDK-iOS_master)](https://jenkins.teads.net/view/Mobile/job/TeadsSDK-iOS_master/)

Teads allows you to integrate a single SDK into your app, and serve premium branded "outstream" video ads from Teads SSP ad server. 
This iOS Demo App includes the Teads Framework and is showing integration examples.

## Build the sample app

* Press 'Clone', wait until repository checkout
* Open TeadsSDKDemo.xcodeproj in XCode 
* Finally, build and test on your device

## Download the Teads SDK iOS library

The Teads SDK is distributed as a .framework file that you have to include in your application. It includes everything you need to serve "outstream" video ads.

Teads iOS SDK ZIP file : [Teads SDK V1.6.6](https://github.com/teads/TeadsSDK-iOS/releases/latest)

## Integration Documentation

Integration instructions are available [on the wiki](https://github.com/teads/TeadsSDK-iOS/wiki).

## SDK updating note

When updating the SDK to a new version in your project, make sure to clean your project before running your app project from menu.

We also recommend you to delete first the old `.framework` and `.bundle` files, and then place the new ones.

Shortcut clean project : &#x21E7; &#x2318; K 

Shortcut clean build folder : &#x2325; &#x21E7; &#x2318; K 


## Changelog

v1.6.6:
- Fixed duplicated symbol with Reachability framework

v1.6.5:
- Fixed specific case when VAST progress event were not sent
- Changed present modal view for fullscreen

v1.6.4:
- Fixed issue introduced in v1.6.0 with wrapped VAST

v1.6.3:
- Fixed bug when inRead inserted in ScrollView with complex hierachy
- Fixed bug for inRead/inBoard in WKWebView
- Fixed bug when opening in safari from the SDK browser
- Added mute/unmute tracking for inFlow

v1.6.2:
- Fixed compatibility for scrollView with `clipToBounds = NO`
- Webview video insertion script enhanced

v1.6.1:
- Fixed dSYM files warning issue

v1.6.0:
- Minimum iOS version required is now iOS 7
- Full iOS 9 support
- BITCODE compliant
- Fixed log error message when server has no ad available 
- Fixed duplicated symbols with Millenium Media SDK
- Minor internal improvements

v1.5.1:
- Fix with TableView section headers
- Fix non-released objects with WebView
- Other minor fixes and improvements

v1.5.0:
- Fixed non-release elements with inRead/inBoard (wk)webview
- Removed unused resources
- Renamed following methods for TeadsNativeVideo :
    - `getNativeVideoView:` => `nativeVideoView:`
    - `getExpandedFrame:`   => `expandedFrame:`
    - `getExpandAnimationDuration:`   => `expandAnimationDuration:`
    - `getCollapseAnimationDuration:` => `collapseAnimationDuration:`

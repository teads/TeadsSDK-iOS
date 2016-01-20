# Teads iOS SDK

Teads allows you to integrate a single SDK into your app, and serve premium branded "outstream" video ads from Teads SSP ad server. 
This iOS Demo App includes the Teads Framework and is showing integration examples.

## Build the sample app

* Press 'Clone', wait until repository checkout
* Open TeadsSDKDemo.xcodeproj in XCode 
* Finally, build and test on your device

## Integration Documentation

Integration instructions are available on [Teads SDK documentation](http://mobile.teads.tv/sdk/documentation/)


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

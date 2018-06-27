# Changelog
v2.7.17
- fix on tableView integration

v2.7.16
- Add support for brandsafety. If you have news content in your app, you should use `[self.teadsAd setPageUrl:@"https://news.com/myArticle"];` where the url is you equivalent http url of your article. More information [http://mobile.teads.tv/sdk/documentation/ios/integration/inread-ios#a-init-your-teads-ad]()

v2.7.15
- Fix regarding changes in Apple guidelines for using UIStatusBarDataNetworkItemView

v2.7.14
- Internal fixes & improvements
- Improvements related to VAST mediafile selection

v2.7.13
- The SDK is now build with Xcode 9. Please use Xcode 9 now as it supports iOS 8+
- UI adjustement for fullscreen on iPhone X
- Fix for (wk)webview integration

v2.7.12
- Fixed an issue with WKWebView delegates when using `reinjectTeadsInWebView`

v2.7.11
- Improved VPAID support for creatives using IMA SDK for HTML

v2.7.10
- Fixed sound been wrongly activated with specific settings from ad server

v2.7.9
- Fixed case where `-teadsAd:didFailLoading:` was not called after a VPAID `AdError`

v2.7.8
- Fixed issue resulting in a build error on Xcode 8

v2.7.7
- Fixes and improvements for display format
- Crash fix for iPhone X

v2.7.6
- Fixes and improvements

v2.7.5
- Improved reinjection in UIWebView
- Improved UX with deeplinks

v2.7.4
- Internal fixes and improvements
- Minor UI improvements
- Fixed I/O audio error log
- Improved VPAID support

v2.7.3
 - Added method `reinjectTeadsInWebView` to be used in case multiple load might be done on a WebView

v2.7.2
 - Fixed a duplicate symbol issue after an update with CocoaPods

v2.7.1
 - Respecting Apple default audio parameter for your app caused to stop other audio streaming apps. This has been fixed.
 - Improved webviews integration support
 - Internal improvements

v2.7.0
 - Added new ad format support
 - Internal improvements
 - Minor internal fixes

v2.6.0
 - Drop iOS 7
 - Minor improvements on the player
 - Minor internal fix

v2.5.6
 - Bug fix for Custom type integration

v2.5.5
 - Bug fixes
 - Internal improvements

v2.5.1
 - iOS 8 layout issue when going fullscreen after rotation

v2.5.0
 - Fixed an issue with video playing in fullscreen
 - Fixes and improvements with AVAudioSession interaction
 - Improved webview integration
 - New endscreen

v2.4.3
 - New method to call if your app uses specific AVAudioSessionCategory : `- (void)requiredAVAudioSession:(NSString *)category`

v2.4.2
 - Fixed an issue causing crash when user arrives on view and immediately goes back
 - Internal improvements

v2.4.1:
 - Fixed player playing issue after rotation
 - Fixed issue coming from rare malformed data from VAST causing crashes
 - Fixed issue with VAST URLs macros causing crashes
 - Fixed blocked UI in ScrollView during inRead expand/collapse 
 - New feature: brand logo

v2.3.4:
 - Fixed issue with status when rotating video fullscreen if app doesn't allow rotation
 - Fixed issue with WKWebView that could block aync loaded content
 - Fixed minor issue with engage format
 - Fixed issue preventing square ad to display in landscape
 - Internal improvements

v2.3.3:
- New engage format
- Fixed issue with sound when app goes in background
- New VAST macros support

v2.3.1:
- SDK should not stop audio from other apps when player is muted
- Fixed an offset issue with inRead Top
- Internal improvements

v2.2.1:
- TeadsVideo is now deprecated, you should use TeadsAd instead
- Fixed issues with iOS 7
- Fixed a bug that can occure with some specific video files
- Fixed some issues with `clean` call
- Fixed last warning logs that may appear
- Internal improvements

v2.1.0:
- Fixed potential crash when video file received is corrupted
- Fixed a typo in callback method `-teadsVideoCanExpand:withRatio:`
- Memory optimizations
- Improved integration in some complex view hierachies
- New TeadsVideo setting available : `maxContainerHeight`
- New branding features

v2.0.4:
- Fixed a crash that can be caused by a corrupted video file
- Fixed small memory leaks
- Fixed the error "Failed to load font" (this won't happen anymore, promised)
- Fixed an occasionnal "unrecognized selector" error log (selector is now recognized)

v2.0.3:
- Minor internal improvements

v2.0.2:
- Fixed ERROR ITMS-90166 that might appear when submitting app to iTunes Connect
- Added support for inRead Vertical

v2.0.0:
- New ad design and behaviors
- Whole new version of SDK that brings breaking changes. Read [Migration guide from SDK v1.x to v2](http://mobile.teads.tv/sdk/documentation/ios/migration-from-sdk-v1-x)

----------
### Old version (SDK v1.x)

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
  - `getExpandedFrame:` => `expandedFrame:`
  - `getExpandAnimationDuration:` => `expandAnimationDuration:`
  - `getCollapseAnimationDuration:` => `collapseAnimationDuration:`

v1.4.4:
- Increased close button touch-zone
- Fixed false log error display
- Bug fixes

v1.4.3:
- Bug fix CoreData migration
- Bug fixes and improvements

v1.4.2:
- Improved VAST handling elements
- Bug fixes and improvements

V1.4.0:
- New feature : Custom Native Video
- New tracking status « isStarted »
- Bug fixes and improvements

v1.3.4:
- Alternative scroll view for web view integrations
- Added callback when no slot found in web view
- Bug fixes and performance improvements

v1.3.3:
- New read-only data about video ad experience
- New playing tracking status
- Bug fixes and improvements

v1.3.2:
- Fullscreen experience is enhanced
- Minor bug fixes and improvements

v1.3.1:
- Fix bug iOS7
- Various bug fixes & Improvements

v1.3.0:
- Improve VAST parsing
- Improve handling of clean functions
- Various bug fixes and improvements
- Improve testing of media files formats

v1.2.0:
- Add support for WKWebView (inRead & inBoard formats)
- Simplified implementation & load process
- Add callbacks about cleaning ads
- Bug fixes & optimizations

v1.1.1:
- Add AdFactory feature for Interstitial ads
- Minor Bug fixes in callbacks

v1.1:
- New build configuration (framework + bundle)
- New AdFactory feature
- Minor Bug fixes & performance improvements

v1.0.1:
- Memory & performance optimization
- Minor bug fixes
- Add reward handling

v1.0:
- First version

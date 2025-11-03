---
title: Migration Guide for Deprecated Teads SDK
sidebar_label: Teads SDK Migration
sidebar_position: 3
---

# Migration Guide for Existing Teads SDK Users

Welcome to the Teads Unified SDK! If you're currently using Teads SDK v5.x, this guide will help you understand what's new and how to take advantage of the enhanced features while maintaining full backward compatibility.

## Key Points

✅ **No Breaking Changes** - Your existing code continues to work without modifications  
✅ **New Features Available** - Access to Feed placements and unified interfaces  
✅ **Enhanced Event System** - More granular event tracking and monitoring  
✅ **Complete Backward Compatibility** - All existing APIs remain fully functional, but are planned to be deprecated later

## What's New

### 1. Unified Placement Creation

While your existing code still works, you now have access to a more convenient unified interface:

#### Previous Approach (Still Works)

```swift
// Traditional Teads SDK approach - still fully supported
let placement = Teads.createMediaPlacement(
    pid: 84242,
    settings: settings,
    delegate: self
)

placement?.requestAd(requestSettings: requestSettings)
```

#### New Unified Approach (Recommended)

Step 1: Create Media placement config
```swift
// New unified interface - cleaner and more intuitive
let config = TeadsAdPlacementMediaConfig(
    pid: 84242,
    articleUrl: URL(string: "https://example.com/article/123")
)
```

Step 2: Create placement:

```swift
let placement = TeadsAdPlacementMedia(config, delegate: self)
let adView = try placement.loadAd()
```

There is also a new generic function on the Teads object that allows you to create any type of placement calling the same function. Please note the config type should match the type of placement.
```swift
let mediaPlacement: TeadsAdPlacementMedia? = Teads.createPlacement(with: config, delegate: self)
let feedPlacement: TeadsAdPlacementFeed? = Teads.createPlacement(with: config, delegate: self)
```


### 2. Access to Feed Placements

You can now integrate Outbrain's content recommendation widgets alongside your video ads:

```swift
// New Feed placement for content recommendations
let feedConfig = TeadsAdPlacementFeedConfig(
    articleUrl: URL(string: "https://example.com/article/123")!,
    widgetId: "MB_1",
    installationKey: "NANOWDGT01",
    widgetIndex: 0,
    userId: nil,
    darkMode: false,
    extId: nil,
    extSecondaryId: nil,
    obPubImp: nil
)

let feedPlacement = TeadsAdPlacementFeed(feedConfig, delegate: self)
let feedView = try feedPlacement.loadAd()
```

### 3. Enhanced Event System

The new unified event system provides consistent event handling across all placement types:

```swift
// Unified event delegate
extension YourViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_ placement: TeadsAdPlacementIdentifiable?,
                    didEmitEvent event: TeadsAdPlacementEventName,
                    data: [String : Any]?) {

        switch event {
        case .ready:      // Ad loaded
        case .rendered:   // Ad displayed
        case .viewed:     // Viewability met
        case .clicked:    // User interaction
        case .failed:     // Error occurred
        // ... more events
        }
    }
}
```

## Migration Scenarios

### Scenario 1: Keep Existing Implementation

If your current implementation is working well, **no action is required**. The SDK maintains full backward compatibility.

```swift
// Your existing code continues to work perfectly
class ExistingViewController: UIViewController, TeadsMediaAdPlacementDelegate {

    var placement: TeadsMediaAdPlacement?

    override func viewDidLoad() {
        super.viewDidLoad()

        // This still works exactly as before
        placement = Teads.createMediaPlacement(
            pid: 84242,
            delegate: self
        )

        let settings = TeadsAdRequestSettings { builder in
            builder.pageUrl("https://example.com/article/123")
        }

        placement?.requestAd(requestSettings: settings)
    }

    // Your existing delegate methods continue to work
    func didReceiveAd(ad: TeadsMediaAd, adRatio: TeadsAdRatio) {
        // Handle ad display
    }
}
```

### Scenario 2: Gradual Migration to New APIs

You can migrate to the new APIs gradually, one placement at a time:

```swift
class MixedImplementationViewController: UIViewController {

    // Mix old and new approaches as needed
    var legacyPlacement: TeadsMediaAdPlacement?  // Old API
    var modernPlacement: TeadsAdPlacementMedia?   // New API
    var feedPlacement: TeadsAdPlacementFeed?      // New feature

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use legacy API for existing placements
        setupLegacyPlacement()

        // Use new API for new features
        setupModernPlacements()
    }

    private func setupLegacyPlacement() {
        // Your existing code
        legacyPlacement = Teads.createMediaPlacement(pid: 84242, delegate: self)
        // ...
    }

    private func setupModernPlacements() {
        // New unified API
        let mediaConfig = TeadsAdPlacementMediaConfig(pid: 84243)
        modernPlacement = TeadsAdPlacementMedia(mediaConfig, delegate: self)

        // New Feed placement
        let feedConfig = TeadsAdPlacementFeedConfig(
            articleUrl: URL(string: "https://example.com/article/123")!,
            widgetId: "MB_1",
            installationKey: "NANOWDGT01",
            widgetIndex: 0
        )
        feedPlacement = TeadsAdPlacementFeed(feedConfig, delegate: self)
    }
}
```

### Scenario 3: Full Migration to Unified APIs

For new implementations or when refactoring, we recommend using the unified APIs:

#### Before (Traditional Approach)

```swift
class TraditionalViewController: UIViewController, TeadsMediaAdPlacementDelegate {

    var placement: TeadsMediaAdPlacement?
    var adView: TeadsMediaAdView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create placement with advanced settings
        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.disableCrashMonitoring()
            settings.disableTeadsAudioSessionManagement()
            settings.disableLocation()
            settings.enableLightEndScreen()
            settings.disableMediaPreload()
            settings.userConsent(subjectToGDPR: "1", consent: "consent_string", tcfVersion: .v2, cmpSdkID: 123)
            settings.setUsPrivacy(consent: "1---")
            settings.setGppConsent(consent: "gpp_string", sectionIds: "2,6,7")
            settings.disableBatteryMonitoring()
            settings.addExtras("key", "value")
            settings.enableDebug()
        }

        placement = Teads.createMediaPlacement(
            pid: 84242,
            settings: placementSettings,
            delegate: self
        )

        // Configure request settings
        let requestSettings = TeadsAdRequestSettings { builder in
            builder.pageUrl("https://example.com/article/123")
            builder.enableValidationMode()  // For testing only
            builder.setMediaScale(.scaleAspectFill)
            builder.addExtras("key", "value")
        }

        // Request ad
        placement?.requestAd(requestSettings: requestSettings)
    }

    // Complete delegate implementation
    func didReceiveAd(ad: TeadsMediaAd, adRatio: TeadsAdRatio) {
        adView = TeadsMediaAdView()
        adView?.bind(ad)

        // Set delegates for additional callbacks
        ad.delegate = self
        ad.playbackDelegate = self

        // Add to view hierarchy
        contentView.addSubview(adView!)

        // Setup constraints with proper height calculation
        let height = adRatio.calculateHeight(for: contentView.bounds.width)
        // Setup constraints...
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        // Handle different failure reasons
        switch reason {
        case .noFill:
            print("No ad available")
        case .networkError:
            print("Network error occurred")
        case .timeout:
            print("Request timed out")
        case .invalidResponse:
            print("Invalid ad response")
        case .generic:
            print("Generic error: \(reason.localizedDescription)")
        }

        // Clean up UI
        adView?.removeFromSuperview()
        adView = nil
    }

    func didUpdateRatio(ad: TeadsMediaAd, adRatio: TeadsAdRatio) {
        // Update layout with new height
        let newHeight = adRatio.calculateHeight(for: contentView.bounds.width)
        // Update constraints...
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // Add tracker view for inventory monitoring
        contentView.addSubview(trackerView)
        // Setup constraints to fill parent...
    }

    func didLogMessage(message: String) {
        // Handle log messages
        print("Teads SDK: \(message)")
    }

    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        // Return view controller for modal presentation
        return self
    }

    func didCatchError(ad: TeadsAd, error: Error) {
        // Handle ad errors
        print("Ad error: \(error)")
    }

    func didClose(ad: TeadsAd) {
        // Handle ad close
        adView?.removeFromSuperview()
        adView = nil
    }

    func didRecordImpression(ad: TeadsAd) {
        // Track impression
        print("Ad impression recorded")
    }

    func didRecordClick(ad: TeadsAd) {
        // Track click
        print("Ad click recorded")
    }

    func didExpandedToFullscreen(ad: TeadsAd) {
        // Handle fullscreen expansion
        print("Ad expanded to fullscreen")
    }

    func didCollapsedFromFullscreen(ad: TeadsAd) {
        // Handle fullscreen collapse
        print("Ad collapsed from fullscreen")
    }
}

// MARK: - TeadsPlaybackDelegate
extension TraditionalViewController: TeadsPlaybackDelegate {

    func adStartPlayingAudio(_ ad: TeadsAd) {
        // Handle audio start
        print("Ad audio started")
    }

    func adStopPlayingAudio(_ ad: TeadsAd) {
        // Handle audio stop
        print("Ad audio stopped")
    }

    func didPlay(_ ad: TeadsAd) {
        // Handle play
        print("Ad started playing")
    }

    func didPause(_ ad: TeadsAd) {
        // Handle pause
        print("Ad paused")
    }

    func didComplete(_ ad: TeadsAd) {
        // Handle completion
        print("Ad completed")
    }
}
```

#### After (Unified Approach)

```swift
class ModernViewController: UIViewController, TeadsAdPlacementEventsDelegate {

    var placement: TeadsAdPlacementMedia?
    var adView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Simplified configuration
        let config = TeadsAdPlacementMediaConfig(
            pid: 84242,
            articleUrl: URL(string: "https://example.com/article/123")
        )

        // Create placement with unified API
        placement = Teads.createPlacement(
            with: config,
            delegate: self
        )

        // Load ad with single method
        do {
            adView = try placement?.loadAd()

            // Add to view hierarchy
            if let adView = adView {
                contentView.addSubview(adView)
                // Setup constraints...
            }
        } catch {
            print("Failed to load ad: \(error)")
        }
    }

    // Unified event handling
    func adPlacement(_ placement: TeadsAdPlacementIdentifiable?,
                    didEmitEvent event: TeadsAdPlacementEventName,
                    data: [String : Any]?) {

        switch event {
        case .ready:
            print("Ad ready")
        case .rendered:
            print("Ad rendered")
        case .viewed:
            print("Ad viewed")
        case .clicked:
            print("Ad clicked")
        case .clickedOrganic:
            print("Organic content clicked")
        case .play:
            print("Ad started playing")
        case .pause:
            print("Ad paused")
        case .complete:
            print("Ad completed")
        case .startPlayAudio:
            print("Ad audio started")
        case .stopPlayAudio:
            print("Ad audio stopped")
        case .heightUpdated:
            if let height = data?["height"] as? CGFloat {
                // No need to do anything, placements handle their own layout
                print("Height updated to: \(height)")
            }
        case .loaded:
            print("Content loaded")
        case .failed:
            if let error = data?["error"] {
                print("Ad failed: \(error)")
            }
        @unknown default:
            print("Unknown event: \(event)")
        }
    }
}
```

## New Features

### Feed Placement Integration

Add content recommendations to keep users engaged:

```swift
class ArticleWithRecommendationsViewController: UIViewController {

    var mediaPlacement: TeadsAdPlacementMedia?    // Your video ad
    var feedPlacement: TeadsAdPlacementFeed?      // New content recommendations

    override func viewDidLoad() {
        super.viewDidLoad()

        // Video ad in the middle of content
        setupVideoAd()

        // Content recommendations at the bottom
        setupContentRecommendations()
    }

    private func setupVideoAd() {
        let config = TeadsAdPlacementMediaConfig(
            pid: 84242,
            articleUrl: URL(string: "https://example.com/article/123")
        )

        mediaPlacement = Teads.createPlacement(with: config, delegate: self)

        if let adView = try? mediaPlacement?.loadAd() {
            // Insert in article content
            articleStackView.insertArrangedSubview(adView, at: 2)
        }
    }

    private func setupContentRecommendations() {
        let config = TeadsAdPlacementFeedConfig(
            articleUrl: URL(string: "https://example.com/article/123")!,
            widgetId: "MB_1",
            installationKey: "NANOWDGT01",
            widgetIndex: 0,
            userId: nil,
            darkMode: false,
            extId: nil,
            extSecondaryId: nil,
            obPubImp: nil
        )

        feedPlacement = Teads.createPlacement(with: config, delegate: self)

        if let feedView = try? feedPlacement?.loadAd() {
            // Add at bottom of article
            articleStackView.addArrangedSubview(feedView)
        }
    }

    // Handle dark mode changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            // Update dark mode for the feed
            feedPlacement?.toggleDarkMode(traitCollection.userInterfaceStyle == .dark)
        }
    }

    // Enable explore more when view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        feedPlacement?.showExploreMore { [weak self] in
            // Called when explore more is dismissed
            self?.feedPlacement = nil
        }
    }
}
```

### Recommendations API

Programmatically fetch recommendations without UI:

```swift
class CustomRecommendationsViewController: UIViewController {

    var recommendationsPlacement: TeadsAdPlacementRecommendations?

    func loadRecommendations() {
        let config = TeadsAdPlacementRecommendationsConfig(
            articleUrl: URL(string: "https://example.com/article/123")!,
            widgetId: "SDK_1",
            widgetIndex: 0
        )

        recommendationsPlacement = Teads.createPlacement(with: config, delegate: self)

        // Traditional callback approach
        recommendationsPlacement?.loadAd { [weak self] response in
            self?.displayRecommendations(response.recommendations)
        }

        // Or modern async/await approach
        Task {
            if let loader = try? recommendationsPlacement?.loadAd() {
                let recommendations = try await loader()
                await displayRecommendations(recommendations)
            }
        }
    }

    private func displayRecommendations(_ recommendations: [OBRecommendation]) {
        // Create your custom UI for recommendations
        for recommendation in recommendations {
            let customView = createCustomRecommendationView(recommendation)
            stackView.addArrangedSubview(customView)
        }
    }
}
```

## Advanced Configuration Options

### 1. Complete Placement Settings

```swift
let placementSettings = TeadsAdPlacementSettings { settings in
    // Crash monitoring
    settings.disableCrashMonitoring()

    // Audio session management
    settings.disableTeadsAudioSessionManagement()

    // Location services
    settings.disableLocation()

    // End screen
    settings.enableLightEndScreen()

    // Media preloading
    settings.disableMediaPreload()

    // Privacy and consent
    settings.userConsent(
        subjectToGDPR: "1",
        consent: "consent_string",
        tcfVersion: .v2,
        cmpSdkID: 123
    )
    settings.setUsPrivacy(consent: "1---")
    settings.setGppConsent(consent: "gpp_string", sectionIds: "2,6,7")

    // Battery monitoring
    settings.disableBatteryMonitoring()

    // Custom extras
    settings.addExtras("key", "value")

    // Debug mode
    settings.enableDebug()
}
```

### 2. Complete Request Settings

```swift
let requestSettings = TeadsAdRequestSettings { settings in
    // Page URL for contextual targeting
    settings.pageUrl("https://yoursite.com/article")

    // Validation mode for testing
    settings.enableValidationMode()

    // Media scale for native ads
    settings.setMediaScale(.scaleAspectFill)

    // Custom extras
    settings.addExtras("key", "value")

    // Mediation ID for adapters
    // settings.mediatedId = "unique_id"
}
```

### 3. Privacy Management

```swift
// Set custom privacy values
TeadsPrivacy.shared.setGDPRConsentString("consent_string")
TeadsPrivacy.shared.setGDPRConsentStringV1("v1_consent_string")
TeadsPrivacy.shared.setGDPRConsentStringV2("v2_consent_string")
TeadsPrivacy.shared.setGDPRApplies(true)
TeadsPrivacy.shared.setUSPrivacyString("1---")
TeadsPrivacy.shared.setGPPString("gpp_string")
TeadsPrivacy.shared.setGPPSections("2,6,7")
TeadsPrivacy.shared.setIDFAConsent(true)

// Request IDFA permission
TeadsPrivacy.shared.requestIDFAPermission { hasConsent in
    print("IDFA consent: \(hasConsent)")
}

// Get IDFA string if authorized
if let idfaString = TeadsPrivacy.shared.idfaString {
    print("IDFA: \(idfaString)")
}
```

## Compatibility Matrix

| Feature             | Teads SDK v5 | Teads SDK v6 | Notes                     |
| ------------------- | -------------- | ------------------ | ------------------------- |
| Media Placement    | ✅             | ✅                 | Fully backward compatible |
| Native Placement    | ✅             | ✅                 | Fully backward compatible |
| Request Settings    | ✅             | ✅                 | All settings preserved    |
| Delegate Methods    | ✅             | ✅                 | Original delegates work   |
| Feed Placement      | ❌             | ✅                 | New feature available     |
| Unified Events      | ❌             | ✅                 | New optional interface    |
| Recommendations API | ❌             | ✅                 | New feature available     |
| Media Native        | ❌             | ✅                 | New API for TeadsNativeAdView |
| Advanced Settings   | ✅             | ✅                 | All settings available    |
| Privacy Management  | ✅             | ✅                 | Enhanced privacy features |


## Support

If you encounter any issues during migration:

1. Check the [Integration Guide](./integration-guide.md) for detailed examples
2. Contact [Support](../Troubleshooting/support.md) for assistance

Remember: **Migration is optional.** Your existing code continues to work, and you can adopt new features at your own pace.

---

_Happy coding with the enhanced Teads Unified SDK!_

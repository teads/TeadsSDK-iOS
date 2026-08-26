//
//  TeadsAdMobMediation.swift
//  TeadsAdMobAdapter
//

import Foundation
import GoogleMobileAds

/// Entry point that links the Teads AdMob custom-event classes into the host application.
@objc public final class TeadsAdMobMediation: NSObject {
    override private init() {
        super.init()
    }

    /// Keeps the Teads custom-event classes in the app binary.
    ///
    /// Google Mobile Ads instantiates `GADMAdapterTeadsBanner`, `GADMAdapterTeadsNative`
    /// and `GADMAdapterTeadsInterstitial` *by name*, from the AdMob dashboard
    /// configuration — nothing in publisher code ever references them. Because the adapter
    /// is distributed as a static framework, a linker that sees no reference to those
    /// classes leaves them out of the app binary. The app then builds, launches and runs
    /// normally, and Teads simply never serves through mediation.
    ///
    /// Calling this from the app supplies the missing reference. Call it once, before
    /// `MobileAds.shared.start(completionHandler:)` or the first ad request:
    ///
    /// ```swift
    /// TeadsAdMobMediation.register()
    /// MobileAds.shared.start()
    /// ```
    ///
    /// CocoaPods integrations get the same effect from the `-ObjC` linker flag that the
    /// Google Mobile Ads podspec applies to the app target automatically. Calling this as
    /// well is harmless, so it is safe to call unconditionally.
    ///
    /// - Returns: the Objective-C names of the linked classes. Also printed automatically
    ///   in debug builds, so a launch log is enough to confirm the classes reached the
    ///   binary — no need to inspect the return value yourself.
    @objc @discardableResult
    public static func register() -> [String] {
        // The names are produced with NSStringFromClass rather than by discarding an array
        // of `.self` values: a discarded metatype array can be folded away before it
        // reaches the object file, which would remove the very references this call exists
        // to create.
        let classNames = [
            NSStringFromClass(GADMAdapterTeadsBanner.self),
            NSStringFromClass(GADMAdapterTeadsNative.self),
            NSStringFromClass(GADMAdapterTeadsInterstitial.self),
        ]
        #if DEBUG
        print("[Teads] TeadsAdMobMediation.register() linked: \(classNames.joined(separator: ", "))")
        #endif
        return classNames
    }
}

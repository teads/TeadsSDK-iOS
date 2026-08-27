// swift-tools-version:5.9

import PackageDescription

// Local package used **only** by the sample apps (`TeadsSampleApp` and
// `TeadsSwiftUISampleApp`).
//
// It mirrors the products of the root `Package.swift` (the ones published to
// SPM consumers) by pointing at the very same xcframeworks in `Frameworks/`
// through the symlinks in `Frameworks/` here, and additionally builds the SAS
// (Equativ) mediation adapter from source: unlike the AdMob and AppLovin
// adapters, it is not shipped as a prebuilt xcframework.
//
// It is kept separate from the root manifest so that SPM consumers of Teads are
// never forced to resolve the SAS SDK. When a product is added to or removed
// from the root `Package.swift`, mirror the change here.
let package = Package(
    name: "TeadsSampleAppDependencies",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "TeadsSDK",
            targets: ["TeadsSDK", "OMSDK_Teads"]
        ),
        .library(
            name: "TeadsAdMobAdapter",
            targets: ["TeadsAdMobAdapter"]
        ),
        .library(
            name: "TeadsAppLovinAdapter",
            targets: ["TeadsAppLovinAdapter"]
        ),
        .library(
            name: "TeadsSASAdapter",
            targets: ["TeadsSASAdapter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/smartadserver/swift-package-manager-display-sdk.git", "7.24.2" ..< "8.0.0")
    ],
    targets: [
        .binaryTarget(
            name: "TeadsSDK",
            path: "Frameworks/TeadsSDK.xcframework"
        ),
        .binaryTarget(
            name: "OMSDK_Teads",
            path: "Frameworks/OMSDK_Teads.xcframework"
        ),
        .binaryTarget(
            name: "TeadsAdMobAdapter",
            path: "Frameworks/TeadsAdMobAdapter.xcframework"
        ),
        .binaryTarget(
            name: "TeadsAppLovinAdapter",
            path: "Frameworks/TeadsAppLovinAdapter.xcframework"
        ),
        // `Sources/TeadsSASAdapter` contains symlinks to `MediationAdapters/TeadsSASAdapter`
        // and `MediationAdapters/Common`, the very same sources the
        // `TeadsSASAdapter.podspec` compiles.
        .target(
            name: "TeadsSASAdapter",
            dependencies: [
                "TeadsSDK",
                .product(name: "SASDisplayKit", package: "swift-package-manager-display-sdk")
            ],
            exclude: ["TeadsSASAdapter/README.md"]
        ),
    ]
)

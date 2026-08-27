// swift-tools-version:5.9

import PackageDescription

// Local package used **only** by the sample apps (`TeadsSampleApp` and
// `TeadsSwiftUISampleApp`).
//
// It exposes the products the sample apps actually use: the `TeadsSDK`,
// `TeadsAdMobAdapter` and `TeadsAppLovinAdapter` xcframeworks of `Frameworks/`
// (reached through the symlinks in `Frameworks/` here, so there is a single
// copy of each binary in the repository), plus the SAS (Equativ) mediation
// adapter built from source: unlike the other adapters, it is not shipped as a
// prebuilt xcframework.
//
// It deliberately does not mirror the whole root `Package.swift`:
// `TeadsPBMPluginRenderer` is left out because no sample uses it, and the SAS
// SDK dependency stays here so that SPM consumers of the root package are never
// forced to resolve it. Add a product here when a sample app starts using one.
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

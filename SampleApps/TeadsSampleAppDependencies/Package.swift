// swift-tools-version:5.9

import PackageDescription

// Local package used **only** by the sample apps (`TeadsSampleApp` and
// `TeadsSwiftUISampleApp`). It builds the SAS (Equativ) mediation adapter from
// source, because – unlike the AdMob and AppLovin adapters – it is not shipped
// as a prebuilt xcframework in the root `Package.swift`. Keeping it here avoids
// forcing every SPM consumer of the Teads package to resolve the SAS SDK.
let package = Package(
    name: "TeadsSampleAppDependencies",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "TeadsSASAdapter",
            targets: ["TeadsSASAdapter"]
        ),
    ],
    dependencies: [
        .package(path: "../.."),
        .package(url: "https://github.com/smartadserver/swift-package-manager-display-sdk.git", .upToNextMajor(from: "7.24.2")),
    ],
    targets: [
        // `Sources/TeadsSASAdapter` contains symlinks to `MediationAdapters/TeadsSASAdapter`
        // and `MediationAdapters/Common`, the very same sources the
        // `TeadsSASAdapter.podspec` compiles.
        .target(
            name: "TeadsSASAdapter",
            dependencies: [
                "TeadsSDK",
                "SASDisplayKit",
            ],
            exclude: ["TeadsSASAdapter/README.md"]
        ),
    ]
)

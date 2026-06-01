// swift-tools-version:5.9

import PackageDescription

// BINARY ADAPTER variant — paths match THIS folder's flat layout (xcframeworks at root).
// All adapters shipped as prebuilt .xcframeworks. No third-party package dependencies
// are declared: consumers who use an adapter MUST add the corresponding third-party SDK
// to their own project (PrebidMobile / GoogleMobileAds / AppLovinSDK).
//
// NOTE: TeadsSDK.xcframework and OMSDK_Teads.xcframework must also be present in this
// folder for the package to resolve. In the public repo, all xcframeworks live under
// Frameworks/ — adjust the `path:` values accordingly when publishing.

let teadsModuleName = "TeadsSDK"
let omModuleName = "OMSDK_Teadstv"
let teadsAdMobAdapterModuleName = "TeadsAdMobAdapter"
let teadsAppLovinAdapterModuleName = "TeadsAppLovinAdapter"
let teadsPBMPluginRendererModuleName = "TeadsPBMPluginRenderer"

let package = Package(
    name: "Teads",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: teadsModuleName,
            targets: [teadsModuleName, omModuleName]
        ),
        .library(
            name: teadsAdMobAdapterModuleName,
            targets: [teadsAdMobAdapterModuleName]
        ),
        .library(
            name: teadsAppLovinAdapterModuleName,
            targets: [teadsAppLovinAdapterModuleName]
        ),
        .library(
            name: teadsPBMPluginRendererModuleName,
            targets: [teadsPBMPluginRendererModuleName]
        ),
    ],

    targets: [
        .binaryTarget(
            name: teadsModuleName,
            path: "Frameworks/\(teadsModuleName).xcframework"
        ),
        .binaryTarget(
            name: omModuleName,
            path: "Frameworks/\(omModuleName).xcframework"
        ),
        .binaryTarget(
            name: teadsAdMobAdapterModuleName,
            path: "Frameworks/\(teadsAdMobAdapterModuleName).xcframework"
        ),
        .binaryTarget(
            name: teadsAppLovinAdapterModuleName,
            path: "Frameworks/\(teadsAppLovinAdapterModuleName).xcframework"
        ),
        .binaryTarget(
            name: teadsPBMPluginRendererModuleName,
            path: "Frameworks/\(teadsPBMPluginRendererModuleName).xcframework"
        ),
    ]
)

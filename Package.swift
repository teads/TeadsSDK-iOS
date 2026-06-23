// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let teadsAdMobAdapterModuleName = "TeadsAdMobAdapter"
let teadsAppLovinAdapterModuleName = "TeadsAppLovinAdapter"
let teadsPBMPluginRendererModuleName = "TeadsPBMPluginRenderer"
let omModuleName = "OMSDK_Teads"

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
        // Adapter xcframeworks are prebuilt binaries. Each adapter bundles its own
        // TeadsAdapterCommon code and references the corresponding third-party SDK
        // (GoogleMobileAds / AppLovinSDK / PrebidMobile) as undefined external symbols.
        // Consumers MUST add the matching third-party SDK to their project themselves.
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

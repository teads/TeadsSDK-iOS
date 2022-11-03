// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let teadsAdMobAdapterModuleName = "TeadsAdMobAdapter"
let omModuleName = "OMSDK_Teadstv"

let package = Package(
    name: teadsModuleName,
    platforms: [
        .iOS(.v10),
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
    ],
    dependencies: [
        .package(name: "GoogleMobileAds", url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "9.0.0"),
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
        .target(name: teadsAdMobAdapterModuleName, dependencies: ["GoogleMobileAds"])
    ]
)

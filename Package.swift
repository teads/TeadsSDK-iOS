// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let teadsAdmobAdapterModuleName = "TeadsAdmobAdapter"
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
            name: teadsAdmobAdapterModuleName,
            targets: [teadsAdmobAdapterModuleName]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "9.0.0"),
        .package(url: "https://github.com/teads/TeadsSDK-iOS.git", from: "5.0.20"),
    ],
    targets: [
        .target(
            name: teadsAdmobAdapterModuleName,
            dependencies: ["GoogleMobileAds", "TeadsSDK"]
        ),
        .binaryTarget(
            name: teadsModuleName,
            path: "\(teadsModuleName).xcframework"
        ),
        .binaryTarget(
            name: omModuleName,
            path: "\(omModuleName).xcframework"
        ),
    ]
)

// swift-tools-version:5.3

import PackageDescription

let teadsAdmobAdapterModuleName = "TeadsAdMobAdapter"

let package = Package(
    name: teadsAdmobAdapterModuleName,
    platforms: [
        .iOS(.v10),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "9.0.0"),
        .package(url: "https://github.com/teads/TeadsSDK-iOS.git", from: "5.0.20"),
    ],
    products: [
        .library(
            name: teadsAdmobAdapterModuleName,
            targets: [teadsAdmobAdapterModuleName]
        ),
    ]
)

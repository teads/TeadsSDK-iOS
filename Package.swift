// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let teadsAdMobAdapterModuleName = "TeadsAdMobAdapter"
let teadsAppLovinAdapterModuleName = "TeadsAppLovinAdapter"
let teadsSASAdapterModuleName = "TeadsSASAdapter"
let mediationAdaptersDirectory = "MediationAdapters"
let googleMobileAdsModuleName = "GoogleMobileAds"
let appLovinMaxModuleName = "AppLovinSDK"
let omModuleName = "OMSDK_Teadstv"
let commonModuleName = "Common"

let package = Package(
    name: "Teads",
    platforms: [
        .iOS(.v10)
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
    ],
    dependencies: [
        .package(
            name: googleMobileAdsModuleName,
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            from: "9.0.0"
        ),
        .package(
            name: appLovinMaxModuleName,
            url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git",
            .upToNextMajor(from: "11.1.1")
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
        .target(
            name: commonModuleName,
            path: "\(mediationAdaptersDirectory)/\(commonModuleName)"
        ),
        .target(
            name: teadsAdMobAdapterModuleName,
            dependencies: [
                .product(name: googleMobileAdsModuleName, package: googleMobileAdsModuleName),
                .target(name: omModuleName),
                .target(name: teadsModuleName),
                .target(name: commonModuleName),
            ],
            path: "\(mediationAdaptersDirectory)/\(teadsAdMobAdapterModuleName)"
        ),
        .target(
            name: teadsAppLovinAdapterModuleName,
            dependencies: [
                .product(name: appLovinMaxModuleName, package: appLovinMaxModuleName),
                .target(name: omModuleName),
                .target(name: teadsModuleName),
                .target(name: commonModuleName),
            ],
            path: "\(mediationAdaptersDirectory)/\(teadsAppLovinAdapterModuleName)"
        ),
    ]
)

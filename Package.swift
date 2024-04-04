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
let commonModuleName = "TeadsAdapterCommon"
let commonModuleNamePath = "Common"

let package = Package(
    name: "Teads",
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
        .library(
            name: teadsAppLovinAdapterModuleName,
            targets: [teadsAppLovinAdapterModuleName]
        ),
    ],
    dependencies: [
        .package(
            name: googleMobileAdsModuleName,
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            "11.0.0" ..< "13.0.0"
        ),
        .package(
            name: appLovinMaxModuleName,
            url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git",
            "11.5.1" ..< "13.0.0"
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
            dependencies: [
                .target(name: teadsModuleName),
                .target(name: omModuleName),
            ],
            path: "\(mediationAdaptersDirectory)/\(commonModuleNamePath)"
        ),
        .target(
            name: teadsAdMobAdapterModuleName,
            dependencies: [
                .product(name: googleMobileAdsModuleName, package: googleMobileAdsModuleName),
                .target(name: commonModuleName),
            ],
            path: "\(mediationAdaptersDirectory)/\(teadsAdMobAdapterModuleName)"
        ),
        .target(
            name: teadsAppLovinAdapterModuleName,
            dependencies: [
                .product(name: appLovinMaxModuleName, package: appLovinMaxModuleName),
                .target(name: commonModuleName),
            ],
            path: "\(mediationAdaptersDirectory)/\(teadsAppLovinAdapterModuleName)"
        ),
    ]
)

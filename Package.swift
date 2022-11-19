// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let teadsAdMobAdapterModuleName = "TeadsAdMobAdapter"
let teadsAppLovinAdapterModuleName = "TeadsAppLovinAdapter"
let teadsSASAdapterModuleName = "TeadsSASAdapter"
let mediationAdaptersDirectory = "MediationAdapters"
let googleMobileAdsModuleName = "GoogleMobileAds"
let commonModuleName = "Common"
let omModuleName = "OMSDK_Teadstv"

let package = Package(
    name: "Teads",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: teadsAdMobAdapterModuleName,
            targets: [teadsAdMobAdapterModuleName]
        ),
    ],
    dependencies: [
        .package(
            name: googleMobileAdsModuleName,
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            from: "9.0.0"
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
            name: teadsAdMobAdapterModuleName,
            dependencies: [
                .product(name: googleMobileAdsModuleName, package: googleMobileAdsModuleName),
                .target(name: omModuleName),
                .target(name: teadsModuleName),
            ],
            path: mediationAdaptersDirectory,
            exclude: [
                teadsAppLovinAdapterModuleName,
                teadsSASAdapterModuleName,
            ]
        ),
    ]
)

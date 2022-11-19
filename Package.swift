// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let teadsAdMobAdapterModuleName = "TeadsAdMobAdapter"
let teadsAppLovinAdapterModuleName = "TeadsAppLovinAdapter"
let teadsSASAdapterModuleName = "TeadsSASAdapter"
let mediationAdaptersDirectory = "MediationAdapters"
let appLovinMaxModuleName = "AppLovinSDK"
let commonModuleName = "Common"
let omModuleName = "OMSDK_Teadstv"

let package = Package(
    name: "Teads",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: teadsAppLovinAdapterModuleName,
            targets: [teadsAppLovinAdapterModuleName]
        ),
    ],
    dependencies: [
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
            name: teadsAppLovinAdapterModuleName,
            dependencies: [
                .product(name: appLovinMaxModuleName, package: appLovinMaxModuleName),
                .target(name: omModuleName),
                .target(name: teadsModuleName),
            ],
            path: mediationAdaptersDirectory,
            exclude: [
                teadsAdMobAdapterModuleName,
                teadsSASAdapterModuleName,
            ]
        ),
    ]
)

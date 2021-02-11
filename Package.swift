// swift-tools-version:5.3

import PackageDescription

let teadsModuleName = "TeadsSDK"
let omModuleName = "OMSDK_Teadstv"

let package = Package(
    name: teadsModuleName,
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: teadsModuleName,
            targets: [teadsModuleName, omModuleName]
        )
    ],
    targets: [
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

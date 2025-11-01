// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "smile_id",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "smile-id", targets: ["smile_id"])
    ],
    dependencies: [
        .package(url: "https://github.com/smileidentity/ios.git", .upToNextMajor(from: "11.1.2"))
    ],
    targets: [
        .target(
            name: "smile_id",
            dependencies: [
                "SmileIDSDK"
            ]
        ),
        .binaryTarget(
            name: "SmileIDSDK",
            url: "https://github.com/smileidentity/ios/releases/download/v11.1.2/SmileIDSDK.xcframework.zip",
            checksum: "623d441897a824e7bf7ed41ac55565d27bc266d4f5872ff94f40043dd7654b42"
        )
    ]
)

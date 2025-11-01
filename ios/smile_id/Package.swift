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
        .package(url: "https://github.com/smileidentity/ios.git", .upToNextMajor(from: "11.1.2")),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", exact: "0.9.20"),
        .package(url: "https://github.com/airbnb/lottie-spm", exact: "4.5.2"),
        .package(url: "https://github.com/fingerprintjs/fingerprintjs-ios", exact: "1.6.0"),
        .package(url: "https://github.com/smileidentity/smile-id-security", exact: "11.1.2"),
        .package(url: "https://github.com/getsentry/sentry-cocoa", exact: "8.57.0")

    ],
    targets: [
        .target(
            name: "smile_id",
            dependencies: [
                "SmileIDSDK",
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "FingerprintJS", package: "fingerprintjs-ios"),
                .product(name: "Sentry", package: "sentry-cocoa"),
                .product(name: "SmileIDSecurity", package: "smile-id-security")
            ],
        )
        .binaryTarget(
            name: "SmileIDSDK",
            url: "https://github.com/smileidentity/ios/releases/download/v11.1.2/SmileIDSDK.xcframework.zip",
            checksum: "623d441897a824e7bf7ed41ac55565d27bc266d4f5872ff94f40043dd7654b42"
        )
    ]
)

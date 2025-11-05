// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "smile_id",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "smile-id",
            targets: ["smile_id"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/smileidentity/ios.git", exact: "11.1.2")
    ],
    targets: [
        .target(
            name: "smile_id",
            dependencies: [
                .product(name: "SmileID", package: "ios")
            ],
            path: "Sources/smile_id"
        )
    ]
)

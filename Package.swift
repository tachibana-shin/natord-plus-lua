// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NatordPlus",
    version: Version(1, 0, 0),
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "NatordPlus",
            targets: ["NatordPlus"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NatordPlus",
            path: "swift/Sources"
        ),
        .testTarget(
            name: "NatordPlusTests",
            dependencies: ["NatordPlus"],
            path: "swift/Tests"
        )
    ]
)

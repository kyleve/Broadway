// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Broadway",
    platforms: [
        .iOS(.v26),
        .macCatalyst(.v26),
    ],
    products: [
        .library(name: "BroadwayCore", targets: ["BroadwayCore"]),
        .library(name: "BroadwayUI", targets: ["BroadwayUI"]),
        .library(name: "BroadwayTesting", targets: ["BroadwayTesting"]),
    ],
    targets: [
        .target(
            name: "BroadwayCore",
            path: "BroadwayCore/Sources",
        ),
        .target(
            name: "BroadwayUI",
            dependencies: [
                .target(name: "BroadwayCore"),
            ],
            path: "BroadwayUI/Sources",
        ),
        .target(
            name: "BroadwayTesting",
            dependencies: [
                .target(name: "BroadwayCore"),
            ],
            path: "BroadwayTesting/Sources",
        ),
    ],
)

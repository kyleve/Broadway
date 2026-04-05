import ProjectDescription

let destinations: Destinations = [.iPhone, .iPad, .macCatalyst]
let deployment: DeploymentTargets = .iOS("26.0")

/// Local Swift package (see root `Package.swift`) for BroadwayCore, BroadwayUI, and BroadwayTesting.
private let broadwayPackage = Package.local(path: .relativeToRoot("."))

func unitTests(
    name: String,
    bundleIdSuffix: String,
    productDependency: String,
    sources: ProjectDescription.SourceFilesList,
) -> Target {
    .target(
        name: name,
        destinations: destinations,
        product: .unitTests,
        bundleId: "com.broadway.\(bundleIdSuffix).tests",
        deploymentTargets: deployment,
        sources: sources,
        dependencies: [
            .package(product: productDependency),
            .package(product: "BroadwayTesting"),
            .target(name: "BroadwayTestHost"),
        ],
    )
}

let project = Project(
    name: "Broadway",
    options: .options(
        defaultKnownRegions: ["en"],
        developmentRegion: "en",
    ),
    packages: [broadwayPackage],
    targets: [
        .target(
            name: "BroadwayCatalog",
            destinations: destinations,
            product: .app,
            bundleId: "com.broadway.catalog",
            deploymentTargets: deployment,
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
                "UIApplicationSupportsIndirectInputEvents": .boolean(true),
            ]),
            sources: ["BroadwayCatalog/Sources/**"],
            resources: ["BroadwayCatalog/Resources/**"],
            dependencies: [
                .package(product: "BroadwayUI"),
            ],
        ),
        .target(
            name: "BroadwayCatalogTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "com.broadway.catalog.tests",
            deploymentTargets: deployment,
            sources: ["BroadwayCatalog/Tests/**"],
            dependencies: [
                .target(name: "BroadwayCatalog"),
                .package(product: "BroadwayTesting"),
            ],
        ),
        .target(
            name: "BroadwayTestHost",
            destinations: destinations,
            product: .app,
            bundleId: "com.broadway.testhost",
            deploymentTargets: deployment,
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
            ]),
            sources: ["BroadwayTestHost/Sources/**"],
            dependencies: [],
        ),
        unitTests(
            name: "BroadwayCoreTests",
            bundleIdSuffix: "core",
            productDependency: "BroadwayCore",
            sources: ["BroadwayCore/Tests/**"],
        ),
        unitTests(
            name: "BroadwayUITests",
            bundleIdSuffix: "ui",
            productDependency: "BroadwayUI",
            sources: ["BroadwayUI/Tests/**"],
        ),
    ],
)

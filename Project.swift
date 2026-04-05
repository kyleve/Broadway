import ProjectDescription

let destinations: Destinations = [.iPhone, .iPad, .macCatalyst]
let deployment: DeploymentTargets = .iOS("26.0")

/// Enables Swift `package` access across all first-party targets (see SE-0386).
private let broadwayPackageAccessSettings = Settings.settings(
    base: [
        "OTHER_SWIFT_FLAGS": .array(["$(inherited)", "-package-name", "Broadway"]),
    ],
)

func framework(
    _ name: String,
    bundleIdSuffix: String,
    dependencies: [TargetDependency] = [],
) -> [Target] {
    [
        .target(
            name: name,
            destinations: destinations,
            product: .framework,
            bundleId: "com.broadway.\(bundleIdSuffix)",
            deploymentTargets: deployment,
            sources: ["\(name)/Sources/**"],
            dependencies: dependencies,
            settings: broadwayPackageAccessSettings,
        ),
        .target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "com.broadway.\(bundleIdSuffix).tests",
            deploymentTargets: deployment,
            sources: ["\(name)/Tests/**"],
            dependencies: [
                .target(name: name),
                .target(name: "BroadwayTesting"),
                .target(name: "BroadwayTestHost"),
            ],
            settings: broadwayPackageAccessSettings,
        ),
    ]
}

let project = Project(
    name: "Broadway",
    options: .options(
        defaultKnownRegions: ["en"],
        developmentRegion: "en",
    ),
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
            dependencies: [.target(name: "BroadwayUI")],
            settings: broadwayPackageAccessSettings,
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
                .target(name: "BroadwayTesting"),
            ],
            settings: broadwayPackageAccessSettings,
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
            settings: broadwayPackageAccessSettings,
        ),
        .target(
            name: "BroadwayTesting",
            destinations: destinations,
            product: .framework,
            bundleId: "com.broadway.testing",
            deploymentTargets: deployment,
            sources: ["BroadwayTesting/Sources/**"],
            dependencies: [
                .target(name: "BroadwayCore"),
                .xctest,
            ],
            settings: broadwayPackageAccessSettings,
        ),
    ]
        + framework("BroadwayUI", bundleIdSuffix: "ui", dependencies: [.target(name: "BroadwayCore")])
        + framework("BroadwayCore", bundleIdSuffix: "core"),
)

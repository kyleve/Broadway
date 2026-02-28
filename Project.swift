import ProjectDescription

let project = Project(
    name: "Broadway",
    options: .options(
        defaultKnownRegions: ["en"],
        developmentRegion: "en"
    ),
    targets: [
        // MARK: - BroadwayCatalog App

        .target(
            name: "BroadwayCatalog",
            destinations: [.iPhone, .iPad, .macCatalyst],
            product: .app,
            bundleId: "com.broadway.catalog",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": .dictionary([:]),
                "UIApplicationSupportsIndirectInputEvents": .boolean(true),
            ]),
            sources: ["BroadwayCatalog/Sources/**"],
            resources: ["BroadwayCatalog/Resources/**"],
            dependencies: [
                .target(name: "BroadwayUI"),
            ]
        ),
        .target(
            name: "BroadwayCatalogTests",
            destinations: [.iPhone, .iPad, .macCatalyst],
            product: .unitTests,
            bundleId: "com.broadway.catalog.tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["BroadwayCatalog/Tests/**"],
            dependencies: [
                .target(name: "BroadwayCatalog"),
            ]
        ),

        // MARK: - BroadwayUI Framework

        .target(
            name: "BroadwayUI",
            destinations: [.iPhone, .iPad, .macCatalyst],
            product: .framework,
            bundleId: "com.broadway.ui",
            deploymentTargets: .iOS("26.0"),
            sources: ["BroadwayUI/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "BroadwayUITests",
            destinations: [.iPhone, .iPad, .macCatalyst],
            product: .unitTests,
            bundleId: "com.broadway.ui.tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["BroadwayUI/Tests/**"],
            dependencies: [
                .target(name: "BroadwayUI"),
            ]
        ),
    ]
)

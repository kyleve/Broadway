<!-- Generated from AGENTS.md — do not edit directly -->

# AGENTS.md — Repository Shape

This document describes the structure and conventions of the Broadway repository for AI agents and contributors.

## Overview

Broadway is a SwiftUI iOS + Mac Catalyst application managed by **Tuist**. The Xcode project is not checked in — it is generated from the `Project.swift` manifest.

## Directory Layout

```
/
├── .githooks/pre-commit                # Git pre-commit hook (SwiftFormat lint)
├── .mise.toml                          # mise tool versions (pins Tuist, SwiftFormat)
├── .swiftformat                        # SwiftFormat configuration
├── Tuist.swift                         # Tuist global configuration
├── Project.swift                       # Tuist project manifest (root level)
├── BroadwayCatalog/
│   ├── Sources/                        # Catalog app source code (Swift / SwiftUI)
│   │   ├── BroadwayApp.swift           # @main entry point
│   │   └── ContentView.swift           # Root view
│   ├── Resources/                      # Bundled resources (assets, localization, etc.)
│   └── Tests/                          # Catalog app unit tests (Swift Testing)
│       └── BroadwayCatalogTests.swift
├── BroadwayUI/
│   ├── Sources/                        # UI framework source code
│   │   └── BRootViewController.swift   # Root container VC (context + trait propagation)
│   └── Tests/                          # UI framework unit tests (Swift Testing)
│       └── BRootViewControllerTests.swift
├── BroadwayTestHost/
│   └── Sources/                        # Minimal app used as test host for unit tests
│       └── TestHostApp.swift           # @main entry point (empty window)
├── BroadwayTesting/
│   └── Sources/                        # Test utilities framework (depends on BroadwayCore)
│       └── BroadwayTesting.swift       # Module entry point
├── BroadwayCore/
│   ├── Sources/                        # Core framework source code
│   │   ├── AnyEquatable.swift          # Type-erased Equatable wrapper
│   │   ├── BAccessibility.swift        # Accessibility snapshot + Observer
│   │   ├── BContext.swift              # Root environment container
│   │   ├── BContext+UITraits.swift     # UITraitDefinition bridge (#if canImport(UIKit))
│   │   ├── BStylesheets.swift          # Lazy cached stylesheet resolver
│   │   ├── BThemes.swift               # Type-keyed theme container
│   │   ├── BTraits.swift               # Type-keyed trait container
│   │   ├── CopyOnWrite.swift           # COW property wrapper
│   │   └── TypeIdentifier.swift        # Lightweight type-keyed identifier
│   └── Tests/                          # Core framework unit tests (Swift Testing)
│       ├── AnyEquatableTests.swift
│       ├── BAccessibilityTests.swift
│       ├── BContextTests.swift
│       ├── BThemesTests.swift
│       ├── BTraitsTests.swift
│       ├── CopyOnWriteTests.swift
│       └── TypeIdentifierTests.swift
├── Plans/                              # Archived implementation plans (see index below)
├── swiftformat                         # Run SwiftFormat (--lint to check only)
├── sync-agents                         # Generate CLAUDE.md + .claude/skills from AGENTS.md
├── ide                                 # Dev script (installs hooks, runs tuist generate)
├── LICENSE                             # Apache 2.0
├── README.md                           # Project overview and setup instructions
└── AGENTS.md                           # This file
```

## Build System

- **Tuist 4+** is used to generate the Xcode project from `Project.swift`.
- Tuist and SwiftFormat are version-pinned via **mise** in `.mise.toml`. Run `mise install` to install them.
- Run `./ide` to generate the Xcode project (or `./ide -i` to run `mise exec -- tuist install` first).
- Run `mise exec -- tuist test` to execute all tests.
- Run `mise exec -- tuist test <SchemeName>` to test a specific target. The scheme name is the **framework name** (e.g., `BroadwayCore`), not the test target name (`BroadwayCoreTests`).
- The generated `.xcodeproj` and `Derived/` directory are git-ignored.

## Formatting

- **SwiftFormat** enforces consistent code style. Configuration lives in `.swiftformat`.
- Run `./swiftformat` to format all Swift files in-place.
- Run `./swiftformat --lint` to check without modifying (used in CI and pre-commit).
- The `./ide` script configures `core.hooksPath` to `.githooks/`, which installs a pre-commit hook that lints staged `.swift` files.
- CI runs `./swiftformat --lint` as a gate before build & test.

## Agent Instructions Sync

`AGENTS.md` is the source of truth for AI agent instructions. Cursor and Codex read nested `AGENTS.md` files natively. Claude Code uses `CLAUDE.md` for instructions and `.claude/skills/` for skills.

- Run `./sync-agents` to generate `CLAUDE.md` files from all `AGENTS.md` files and sync `.agents/skills/` to `.claude/skills/`.
- Generated `CLAUDE.md` files contain a marker comment on the first line. The script uses this marker to clean up stale files on subsequent runs.
- Skills live in `.agents/skills/` (read natively by Cursor and Codex) and are copied to `.claude/skills/` for Claude Code.
- The pre-commit hook runs `./sync-agents --git-add` automatically to keep generated files in sync.

## Targets

| Target | Type | Bundle ID | Destinations | Min Deployment |
|---|---|---|---|---|
| `BroadwayCatalog` | `.app` | `com.broadway.catalog` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayCatalogTests` | `.unitTests` | `com.broadway.catalog.tests` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayUI` | `.framework` | `com.broadway.ui` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayUITests` | `.unitTests` | `com.broadway.ui.tests` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayCore` | `.framework` | `com.broadway.core` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayCoreTests` | `.unitTests` | `com.broadway.core.tests` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayTestHost` | `.app` | `com.broadway.testhost` | iPhone, iPad, Mac Catalyst | iOS 26.0 |
| `BroadwayTesting` | `.framework` | `com.broadway.testing` | iPhone, iPad, Mac Catalyst | iOS 26.0 |

### Dependency Graph

```
BroadwayCatalog (app) ──▶ BroadwayUI (framework) ──▶ BroadwayCore (framework)
                                                            ▲
BroadwayTestHost (app) ──▶ BroadwayUI ──────────────────────┤
                                                            │
BroadwayTesting (framework) ────────────────────────────────┘

All framework test targets use BroadwayTestHost and depend on BroadwayTesting.
```

## Key Conventions

- **Shell scripts** should be kept short (≤ ~20 lines). For anything longer, use **Ruby** for readability and portability.
- **SwiftUI** is the UI framework. Catalog app views live under `BroadwayCatalog/Sources/`.
- **BroadwayUI** is the reusable component library. All shared UI lives under `BroadwayUI/Sources/`.
- **BroadwayCore** provides foundational utilities and shared logic. Source lives under `BroadwayCore/Sources/`.
- **BroadwayTestHost** is a minimal app that serves as the test host for framework unit tests. Source lives under `BroadwayTestHost/Sources/`.
- **BroadwayTesting** provides shared test utilities. All test targets depend on it. Source lives under `BroadwayTesting/Sources/`.
- **Swift Testing** (`import Testing`) is used for unit tests, not XCTest.
- Source files use `<Target>/Sources/**` globs; test files use `<Target>/Tests/**`.
- Resources (asset catalogs, localization files, etc.) go in `BroadwayCatalog/Resources/`.
- The catalog app uses `@main` via `BroadwayApp.swift` as the app entry point.
- Info.plist is auto-generated by Tuist via `infoPlist: .extendingDefault(with:)`.

## Plans

Implementation plans are stored in the `Plans/` directory. When you develop a plan using Cursor's plan mode, copy the final plan into `Plans/` and add an entry to the index below.

**Naming convention**: `<NNN>-<YYYY-MM-DD>-<slug>.md`, where `<NNN>` is the next sequential number (zero-padded to 3 digits), `<YYYY-MM-DD>` is the date the plan was created, and `<slug>` is a short snake_case description. For example: `002-2026-03-15-dark_mode_support.md`.

## Adding New Files

- **New catalog app files**: Add `.swift` files to `BroadwayCatalog/Sources/`.
- **New UI components**: Add `.swift` files to `BroadwayUI/Sources/`. Mark public API as `public`.
- **New test files**: Add `.swift` files to the appropriate `Tests/` directory.
- **New resources**: Add to `BroadwayCatalog/Resources/`. They are bundled via the `Resources/**` glob.
- **New targets or dependencies**: Edit `Project.swift` at the repository root.

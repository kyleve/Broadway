# Broadway

An open-source iOS and Mac Catalyst design system prototype.

## Requirements

- Xcode 16+
- [mise](https://mise.jdx.dev) (manages Tuist and SwiftFormat automatically)
- iOS 26.0+

## Getting Started

### Install mise

```bash
curl https://mise.run | sh
```

Or via Homebrew:

```bash
brew install mise
```

### Set Up the Project

```bash
mise install       # Install pinned versions of Tuist and SwiftFormat
./ide -i           # Install dependencies, fetch external skills, generate Xcode project
```

After the initial setup, run `./ide` (without `-i`) to regenerate the Xcode project without re-installing dependencies.

The `./ide` script also configures a Git pre-commit hook that automatically formats staged Swift files with SwiftFormat and keeps generated AI agent configuration in sync.

### Run Tests

```bash
tuist test
```

Use `tuist test BroadwayCoreTests` or `tuist test BroadwayUITests` to run a single bundle. Core/UI **libraries** are defined in `Package.swift` (there is no `BroadwayCore` Xcode scheme—libraries build via the embedded Swift package).

Or open the generated workspace in Xcode and run tests with **Cmd+U**.

## Project Structure

```
/
├── .githooks/              # Git hooks (pre-commit SwiftFormat)
├── BroadwayCatalog/        # Catalog app (Sources/, Resources/, Tests/)
├── BroadwayUI/             # UI framework (Sources/, Tests/)
├── BroadwayCore/           # Core framework (Sources/, Tests/)
├── BroadwayTestHost/       # Minimal test host app (Sources/)
├── BroadwayTesting/        # Shared test utilities (Sources/)
├── Plans/                  # Archived implementation plans
├── Package.swift           # SPM libraries (Core, UI, Testing)
├── Project.swift           # Tuist: apps, test host, xctest bundles
├── Tuist.swift             # Tuist global configuration
├── ide                     # Dev setup script
├── swiftformat             # Run SwiftFormat
└── sync-agents             # Sync AI agent configuration across tools
```

## Targets

**Swift package** (`Package.swift`): **BroadwayCore**, **BroadwayUI**, and **BroadwayTesting** library products.

**Tuist / Xcode** (`Project.swift`):

| Target | Product | Destinations |
|---|---|---|
| **BroadwayCatalog** | App | iOS, Mac Catalyst |
| **BroadwayCatalogTests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayCoreTests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayUITests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayTestHost** | App (test host) | iOS, Mac Catalyst |

## AI Agent Skills

External skills are managed via `sync-agents`. The manifest at `.agents/external-skills.json` tracks installed skills pinned to specific commits.

```bash
./sync-agents --add <github-url> [name]   # Add a new skill from GitHub
./sync-agents --update                    # Update all skills to latest
./sync-agents --install                   # Fetch skills from the manifest
```

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

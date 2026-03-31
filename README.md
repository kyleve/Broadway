# Broadway

An open-source iOS and Mac Catalyst design system prototype.

## Requirements

- Xcode 16+
- [mise](https://mise.jdx.dev) (manages Tuist automatically)
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

### Install Tools & Generate

```bash
mise install          # Installs the pinned version of Tuist from .mise.toml
./ide                 # Generates the Xcode project
./ide -i              # Runs tuist install first, then generates
```

### Run Tests

```bash
tuist test
```

Or open the generated project in Xcode and run tests with **Cmd+U**.

## Project Structure

```
Broadway/
├── BroadwayCatalog/
│   ├── Sources/            # Catalog app source code
│   ├── Resources/          # Asset catalogs, etc.
│   └── Tests/              # Catalog app unit tests
├── BroadwayUI/
│   ├── Sources/            # UI framework source code
│   └── Tests/              # UI framework unit tests
├── BroadwayCore/
│   ├── Sources/            # Core framework source code
│   └── Tests/              # Core framework unit tests
├── BroadwayTestHost/
│   └── Sources/            # Minimal test host app
├── BroadwayTesting/
│   └── Sources/            # Shared test utilities
└── Plans/                  # Archived implementation plans
```

## Targets

| Target | Product | Destinations |
|---|---|---|
| **BroadwayCatalog** | App | iOS, Mac Catalyst |
| **BroadwayCatalogTests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayUI** | Framework | iOS, Mac Catalyst |
| **BroadwayUITests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayCore** | Framework | iOS, Mac Catalyst |
| **BroadwayCoreTests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayTestHost** | App | iOS, Mac Catalyst |
| **BroadwayTesting** | Framework | iOS, Mac Catalyst |

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

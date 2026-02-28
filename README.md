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
├── .mise.toml                          # mise tool versions (pins Tuist)
├── Tuist.swift                         # Tuist configuration
├── Project.swift                       # Tuist project manifest
├── BroadwayCatalog/
│   ├── Sources/                        # Catalog app source files
│   │   ├── BroadwayApp.swift           # @main app entry point
│   │   └── ContentView.swift           # Root SwiftUI view
│   ├── Resources/                      # Asset catalogs, etc.
│   └── Tests/                          # Catalog app unit tests
│       └── BroadwayCatalogTests.swift
├── BroadwayUI/
│   ├── Sources/                        # UI framework source files
│   │   └── BroadwayUI.swift
│   └── Tests/                          # UI framework unit tests
│       └── BroadwayUITests.swift
├── ide                                 # Dev script (generate project)
├── LICENSE                             # Apache 2.0
└── README.md
```

## Targets

| Target | Product | Destinations |
|---|---|---|
| **BroadwayCatalog** | App | iOS, Mac Catalyst |
| **BroadwayCatalogTests** | Unit Tests | iOS, Mac Catalyst |
| **BroadwayUI** | Framework | iOS, Mac Catalyst |
| **BroadwayUITests** | Unit Tests | iOS, Mac Catalyst |

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

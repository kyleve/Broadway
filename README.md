# Broadway

An open-source iOS and Mac Catalyst design system prototype.

## Requirements

- Xcode 16+
- [mise](https://mise.jdx.dev) (manages Tuist automatically)
- iOS 26.0+

## Getting Started

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
BroadwayCatalog/          # Catalog app (Sources/, Resources/, Tests/)
BroadwayUI/               # Reusable UI component framework (Sources/, Tests/)
BroadwayCore/             # Foundational utilities framework (Sources/, Tests/)
BroadwayTestHost/         # Minimal test host app
BroadwayTesting/          # Shared test utilities framework
Plans/                    # Archived implementation plans
Project.swift             # Tuist project manifest
ide                       # Dev script (generate project)
```

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

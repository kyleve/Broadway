---
name: GitHub CI Setup
overview: Add a GitHub Actions workflow that builds and tests all targets on pull requests and pushes to main, using mise to install the pinned Tuist version on a macOS 26 runner.
todos:
  - id: create-workflow
    content: Create .github/workflows/ci.yml with the build + test workflow
    status: completed
isProject: false
---

# GitHub CI Setup

## Approach

Create a single workflow file at `.github/workflows/ci.yml` that:

1. Triggers on **pull requests** and **pushes to main**
2. Runs on `macos-26` (ARM, GA as of Feb 26 2026 -- includes Xcode 26.x with the iOS 26 SDK)
3. Uses `jdx/mise-action@v3` to install Tuist at the version pinned in `[.mise.toml](.mise.toml)` (currently 4.40.0)
4. Runs `tuist test` to build and execute all test targets (`BroadwayCatalogTests` + `BroadwayUITests`)

## Workflow file

`.github/workflows/ci.yml` -- roughly:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  test:
    name: Build & Test
    runs-on: macos-26
    steps:
      - uses: actions/checkout@v4
      - uses: jdx/mise-action@v3
      - run: tuist test
```

Key details:

- `**concurrency**` cancels redundant in-flight runs for the same branch (saves CI minutes)
- `**jdx/mise-action@v3**` reads `.mise.toml`, installs + activates Tuist 4.40.0, and caches it across runs
- `**tuist test**` generates the project and runs all unit test targets in one command
- No need for `tuist generate` separately since `tuist test` handles it


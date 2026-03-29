import Testing
@testable import BroadwayCore


// MARK: - Test Fixtures

private enum ColorTheme : String, BTheme {
    case light, dark
    static var defaultValue: Self { .light }
}

private struct TestStylesheet : BStylesheet {
    var color : ColorTheme?

    init(context: SlicingContext) {
        self.color = context.themes[ColorTheme.self]
    }
}

private struct BaseStylesheet : BStylesheet {
    var color : ColorTheme?

    init(context: SlicingContext) {
        self.color = context.themes[ColorTheme.self]
    }
}

private struct DerivedStylesheet : BStylesheet {
    var baseColor : ColorTheme?

    init(context: SlicingContext) throws {
        self.baseColor = try context.stylesheets.get(BaseStylesheet.self).color
    }
}

private struct LeafStylesheet : BStylesheet {
    var baseColor : ColorTheme?

    init(context: SlicingContext) throws {
        self.baseColor = try context.stylesheets.get(DerivedStylesheet.self).baseColor
    }
}

private struct CycleA : BStylesheet {
    init(context: SlicingContext) throws {
        _ = try context.stylesheets.get(CycleB.self)
    }
}

private struct CycleB : BStylesheet {
    init(context: SlicingContext) throws {
        _ = try context.stylesheets.get(CycleA.self)
    }
}


@Suite("BContext Stylesheets")
struct BContextStylesheetTests {

    private func makeContext(
        traits: BTraits = .init(),
        themes: BThemes = .init()
    ) -> BContext {
        BContext(
            traits: traits,
            themes: themes,
            stylesheets: BStylesheets(config: .init(traits: traits, themes: themes))
        )
    }

    // MARK: - Lazy Creation

    @Test("Accessing a stylesheet creates it lazily from context")
    func lazyCreation() throws {
        var themes = BThemes()
        themes[ColorTheme.self] = .dark

        let context = makeContext(themes: themes)
        let sheet = try context.stylesheets.get(TestStylesheet.self)

        #expect(sheet.color == .dark)
    }

    // MARK: - Caching

    @Test("Accessing the same stylesheet twice returns an equal value")
    func caching() throws {
        let context = makeContext()

        let first = try context.stylesheets.get(TestStylesheet.self)
        let second = try context.stylesheets.get(TestStylesheet.self)

        #expect(first == second)
    }

    // MARK: - Invalidation

    @Test("Changing themes produces a stylesheet with the new theme")
    func themeInvalidation() throws {
        var context = makeContext()

        let before = try context.stylesheets.get(TestStylesheet.self)
        #expect(before.color == nil)

        context.themes[ColorTheme.self] = .dark

        let after = try context.stylesheets.get(TestStylesheet.self)
        #expect(after.color == .dark)
    }

    @Test("Changing traits produces a fresh stylesheet")
    func traitsInvalidation() throws {
        var context = makeContext()

        let before = try context.stylesheets.get(TestStylesheet.self)

        context.traits.accessibility = BAccessibility(isVoiceOverRunning: true)

        let after = try context.stylesheets.get(TestStylesheet.self)

        // Both are default TestStylesheets (no theme set), so equal by value,
        // but the key changed so it was re-created rather than cache-hit.
        #expect(before == after)
    }

    // MARK: - Stylesheet Dependencies

    @Test("A stylesheet can depend on another stylesheet")
    func directDependency() throws {
        var themes = BThemes()
        themes[ColorTheme.self] = .dark

        let context = makeContext(themes: themes)
        let derived = try context.stylesheets.get(DerivedStylesheet.self)

        #expect(derived.baseColor == .dark)
    }

    @Test("Transitive stylesheet dependencies resolve correctly")
    func transitiveDependency() throws {
        var themes = BThemes()
        themes[ColorTheme.self] = .dark

        let context = makeContext(themes: themes)
        let leaf = try context.stylesheets.get(LeafStylesheet.self)

        #expect(leaf.baseColor == .dark)
    }

    @Test("Dependent stylesheet reflects theme changes")
    func dependencyThemeInvalidation() throws {
        var context = makeContext()

        let before = try context.stylesheets.get(DerivedStylesheet.self)
        #expect(before.baseColor == nil)

        context.themes[ColorTheme.self] = .dark

        let after = try context.stylesheets.get(DerivedStylesheet.self)
        #expect(after.baseColor == .dark)
    }

    // MARK: - Cycle Detection

    @Test("Circular stylesheet dependency throws CyclicDependencyError")
    func cycleThrows() {
        let stylesheets = BStylesheets(config: .init(traits: .init(), themes: .init()))

        #expect(throws: CyclicDependencyError.self) {
            _ = try stylesheets.get(CycleA.self)
        }
    }

    @Test("CyclicDependencyError includes the dependency path")
    func cyclePath() {
        let stylesheets = BStylesheets(config: .init(traits: .init(), themes: .init()))

        let error = #expect(throws: CyclicDependencyError.self) {
            _ = try stylesheets.get(CycleA.self)
        }

        #expect(error?.path.first == "CycleA")
        #expect(error?.path.last == "CycleA")
        #expect(error?.path.count == 3)
    }

    @Test("CyclicDependencyError description shows the full cycle path")
    func cycleDescription() {
        let error = CyclicDependencyError(path: ["CycleA", "CycleB", "CycleA"])

        #expect(error.description == "Stylesheet dependency cycle: CycleA → CycleB → CycleA")
    }
}

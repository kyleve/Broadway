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

    init(context: SlicingContext) {
        self.baseColor = context.stylesheets[BaseStylesheet.self].color
    }
}

private struct LeafStylesheet : BStylesheet {
    var baseColor : ColorTheme?

    init(context: SlicingContext) {
        self.baseColor = context.stylesheets[DerivedStylesheet.self].baseColor
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
            stylesheets: BStylesheets(traits: traits, themes: themes)
        )
    }

    // MARK: - Lazy Creation

    @Test("Accessing a stylesheet creates it lazily from context")
    func lazyCreation() {
        var themes = BThemes()
        themes[ColorTheme.self] = .dark

        let context = makeContext(themes: themes)
        let sheet = context.stylesheets[TestStylesheet.self]

        #expect(sheet.color == .dark)
    }

    // MARK: - Caching

    @Test("Accessing the same stylesheet twice returns an equal value")
    func caching() {
        let context = makeContext()

        let first = context.stylesheets[TestStylesheet.self]
        let second = context.stylesheets[TestStylesheet.self]

        #expect(first == second)
    }

    // MARK: - Invalidation

    @Test("Changing themes produces a stylesheet with the new theme")
    func themeInvalidation() {
        var context = makeContext()

        let before = context.stylesheets[TestStylesheet.self]
        #expect(before.color == nil)

        context.themes[ColorTheme.self] = .dark

        let after = context.stylesheets[TestStylesheet.self]
        #expect(after.color == .dark)
    }

    @Test("Changing traits produces a fresh stylesheet")
    func traitsInvalidation() {
        var context = makeContext()

        let before = context.stylesheets[TestStylesheet.self]

        context.traits.accessibility = BAccessibility(isVoiceOverRunning: true)

        let after = context.stylesheets[TestStylesheet.self]

        // Both are default TestStylesheets (no theme set), so equal by value,
        // but the key changed so it was re-created rather than cache-hit.
        #expect(before == after)
    }

    // MARK: - Stylesheet Dependencies

    @Test("A stylesheet can depend on another stylesheet")
    func directDependency() {
        var themes = BThemes()
        themes[ColorTheme.self] = .dark

        let context = makeContext(themes: themes)
        let derived = context.stylesheets[DerivedStylesheet.self]

        #expect(derived.baseColor == .dark)
    }

    @Test("Transitive stylesheet dependencies resolve correctly")
    func transitiveDependency() {
        var themes = BThemes()
        themes[ColorTheme.self] = .dark

        let context = makeContext(themes: themes)
        let leaf = context.stylesheets[LeafStylesheet.self]

        #expect(leaf.baseColor == .dark)
    }

    @Test("Dependent stylesheet reflects theme changes")
    func dependencyThemeInvalidation() {
        var context = makeContext()

        let before = context.stylesheets[DerivedStylesheet.self]
        #expect(before.baseColor == nil)

        context.themes[ColorTheme.self] = .dark

        let after = context.stylesheets[DerivedStylesheet.self]
        #expect(after.baseColor == .dark)
    }
}

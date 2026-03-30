@testable import BroadwayCore
import Testing

private enum Palette: String, BTheme {
    case light, dark
}

private enum Typography: String, BTheme {
    case standard, compact
}

struct BThemesTests {
    // MARK: - Nil for Unset

    @Test("Unset theme returns nil")
    func unsetReturnsNil() {
        let themes = BThemes()
        #expect(themes[Palette.self] == nil)
    }

    // MARK: - Set / Get

    @Test("Set and get roundtrip")
    func setGetRoundtrip() {
        var themes = BThemes()
        themes[Palette.self] = .dark
        #expect(themes[Palette.self] == .dark)
    }

    @Test("Setting a theme twice uses the latest value")
    func overwrite() {
        var themes = BThemes()
        themes[Palette.self] = .light
        themes[Palette.self] = .dark
        #expect(themes[Palette.self] == .dark)
    }

    @Test("Multiple theme types coexist")
    func multipleTypes() {
        var themes = BThemes()
        themes[Palette.self] = .dark
        themes[Typography.self] = .compact

        #expect(themes[Palette.self] == .dark)
        #expect(themes[Typography.self] == .compact)
    }

    // MARK: - Removal

    @Test("Assigning nil removes the theme")
    func removalViaNil() {
        var themes = BThemes()
        themes[Palette.self] = .dark
        themes[Palette.self] = nil
        #expect(themes[Palette.self] == nil)
    }

    // MARK: - Equatable

    @Test("Two empty instances are equal")
    func emptyEquality() {
        #expect(BThemes() == BThemes())
    }

    @Test("Instances with the same content are equal")
    func sameContentEqual() {
        var a = BThemes()
        a[Palette.self] = .dark
        var b = BThemes()
        b[Palette.self] = .dark
        #expect(a == b)
    }

    @Test("Instances with different content are not equal")
    func differentContentNotEqual() {
        var a = BThemes()
        a[Palette.self] = .light
        var b = BThemes()
        b[Palette.self] = .dark
        #expect(a != b)
    }

    // MARK: - Value Semantics

    @Test("Mutating a copy does not affect the original")
    func copyIndependence() {
        var a = BThemes()
        a[Palette.self] = .light
        var b = a
        b[Palette.self] = .dark

        #expect(a[Palette.self] == .light)
        #expect(b[Palette.self] == .dark)
    }
}

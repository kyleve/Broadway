import Testing
@testable import BroadwayCore

@Suite("BroadwayCore Tests")
struct BroadwayCoreTests {

    @Test("BroadwayCore module is importable")
    func moduleExists() {
        #expect(true)
    }

    // MARK: - Theme

    @Test("Light and dark themes have distinct names")
    func themeNames() {
        #expect(BroadwayTheme.light.name == "Light")
        #expect(BroadwayTheme.dark.name == "Dark")
        #expect(BroadwayTheme.light.name != BroadwayTheme.dark.name)
    }

    @Test("Themes are not equal to each other")
    func themeEquality() {
        #expect(BroadwayTheme.light != BroadwayTheme.dark)
        #expect(BroadwayTheme.light == BroadwayTheme.light)
    }

    @Test("Theme hashing uses name")
    func themeHashing() {
        #expect(BroadwayTheme.light.hashValue == BroadwayTheme.light.hashValue)
        #expect(BroadwayTheme.light.hashValue != BroadwayTheme.dark.hashValue)
    }

    // MARK: - Spacing Tokens

    @Test("Default spacing follows 4-pt grid")
    func defaultSpacing() {
        let spacing = SpacingTokens.default
        #expect(spacing.xs == 4)
        #expect(spacing.sm == 8)
        #expect(spacing.md == 16)
        #expect(spacing.lg == 24)
        #expect(spacing.xl == 32)
        #expect(spacing.xxl == 48)
    }

    // MARK: - Shape Tokens

    @Test("Default shape tokens have expected values")
    func defaultShape() {
        let shape = ShapeTokens.default
        #expect(shape.cornerRadiusSmall == 4)
        #expect(shape.cornerRadiusMedium == 8)
        #expect(shape.cornerRadiusLarge == 16)
        #expect(shape.borderWidth == 1)
    }

    // MARK: - Custom Theme

    @Test("Custom theme can override individual tokens")
    func customTheme() {
        var custom = BroadwayTheme.light
        custom.name = "Custom"
        custom.spacing.md = 20

        #expect(custom.name == "Custom")
        #expect(custom.spacing.md == 20)
        #expect(custom.spacing.sm == BroadwayTheme.light.spacing.sm)
    }
}

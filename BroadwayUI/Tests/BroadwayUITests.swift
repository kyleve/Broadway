import Testing
import SwiftUI
@testable import BroadwayUI
@testable import BroadwayCore

@Suite("BroadwayUI Tests")
struct BroadwayUITests {

    @Test("BroadwayUI module is importable")
    func moduleExists() {
        #expect(true)
    }

    @Test("BroadwayButton can be created with primary style")
    func primaryButton() {
        let button = BroadwayButton("Tap me", style: .primary) {}
        #expect(button != nil)
    }

    @Test("BroadwayButton can be created with secondary style")
    func secondaryButton() {
        let button = BroadwayButton("Tap me", style: .secondary) {}
        #expect(button != nil)
    }

    @Test("BroadwayCard can wrap content")
    func card() {
        let card = BroadwayCard { Text("Hello") }
        #expect(card != nil)
    }

    @Test("BroadwayText supports all roles")
    func textRoles() {
        let roles: [BroadwayTextRole] = [
            .displayLarge, .titleLarge, .titleMedium,
            .bodyLarge, .bodyMedium, .caption,
        ]
        for role in roles {
            let text = BroadwayText("Test", role: role)
            #expect(text != nil)
        }
    }

    @Test("Default theme environment key is light")
    func defaultEnvironmentTheme() {
        let env = EnvironmentValues()
        #expect(env.broadwayTheme == BroadwayTheme.light)
    }
}

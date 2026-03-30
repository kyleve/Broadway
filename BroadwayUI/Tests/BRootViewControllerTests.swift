#if canImport(UIKit)

import Testing
import UIKit
import SwiftUI
@testable import BroadwayUI
import BroadwayCore


@Suite("BRootViewController")
struct BRootViewControllerTests {

    // MARK: - Initialization

    @Test("Starts with a default context")
    func defaultContext() {
        let vc = BRootViewController(child: UIViewController())
        #expect(vc.context == BContext())
    }

    @Test("Accepts initial themes")
    func initialThemes() {
        var themes = BThemes()
        themes[TestTheme.self] = .custom

        let vc = BRootViewController(themes: themes, child: UIViewController())
        #expect(vc.context.themes[TestTheme.self] == .custom)
    }

    @Test("Convenience init wraps SwiftUI content")
    func swiftUIConvenience() {
        let vc = BRootViewController {
            Text("Hello")
        }
        #expect(vc.context == BContext())
    }

    // MARK: - Themes

    @Test("Setting themes updates the context")
    func setThemes() {
        let vc = BRootViewController(child: UIViewController())
        vc.themes[TestTheme.self] = .custom

        #expect(vc.context.themes[TestTheme.self] == .custom)
    }

    // MARK: - Child Containment

    @Test("Child is embedded after loading the view")
    func childEmbedded() {
        let child = UIViewController()
        let root = BRootViewController(child: child)

        root.loadViewIfNeeded()

        #expect(child.parent === root)
        #expect(child.view.superview === root.view)
    }

    // MARK: - Trait Propagation

    @Test("Context is written into traitOverrides after viewDidLoad")
    func traitOverrideSet() {
        let vc = BRootViewController(child: UIViewController())
        vc.loadViewIfNeeded()

        #expect(vc.traitOverrides.bContext == vc.context)
    }
}


// MARK: - Fixtures

private enum TestTheme : String, BTheme {
    case standard, custom
    static var defaultValue : Self { .standard }
}

#endif

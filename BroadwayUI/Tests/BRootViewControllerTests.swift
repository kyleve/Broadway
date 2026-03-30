#if canImport(UIKit)

import Testing
import UIKit
import SwiftUI
@testable import BroadwayUI
import BroadwayCore


@Suite("BRootViewController")
@MainActor struct BRootViewControllerTests {

    // MARK: - Initialization

    @Test("Context traits reflect the live accessibility snapshot")
    func contextHasLiveAccessibility() {
        let vc = BRootViewController(child: UIViewController())
        #expect(vc.context.traits.accessibility == BAccessibility.current())
    }

    @Test("Convenience init wraps SwiftUI content")
    func swiftUIConvenience() {
        let vc = BRootViewController {
            Text("Hello")
        }
        #expect(vc.context.traits.accessibility == BAccessibility.current())
    }

    // MARK: - Child Containment

    @Test("Child is added to parent in init")
    func childAddedInInit() {
        let child = UIViewController()
        let root = BRootViewController(child: child)

        #expect(child.parent === root)
    }

    @Test("Child view is added as subview after loading")
    func childViewEmbedded() {
        let child = UIViewController()
        let root = BRootViewController(child: child)

        root.loadViewIfNeeded()

        #expect(child.view.superview === root.view)
    }

    // MARK: - Trait Propagation

    @Test("Context is written into traitOverrides at init")
    func traitOverrideSet() {
        let vc = BRootViewController(child: UIViewController())
        #expect(vc.traitOverrides.bContext == vc.context)
    }

}

#endif

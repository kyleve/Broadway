//
//  BRootViewController.swift
//  BroadwayUI
//

#if canImport(UIKit)

import UIKit
import SwiftUI
import BroadwayCore


/// A container view controller that owns the root ``BContext`` and
/// propagates it to all descendants via a custom `UITraitCollection` trait.
///
/// `BRootViewController` manages the ``BAccessibility/Observer``,
/// keeping ``BContext/traits`` in sync with system accessibility changes
/// and re-publishing the updated context through `traitOverrides`.
///
/// Use the designated initializer to wrap an arbitrary child view controller,
/// or the convenience initializer to embed SwiftUI content directly.
///
/// ```swift
/// let root = BRootViewController {
///     ContentView()
/// }
/// window.rootViewController = root
/// ```
public final class BRootViewController : UIViewController {

    // MARK: Public

    /// The current context. Updated automatically when accessibility
    /// settings change. Read this to inspect the live state.
    public private(set) var context : BContext

    /// The active theme values. Setting this updates the context and
    /// re-propagates the trait to all descendants.
    public var themes : BThemes {
        get { context.themes }
        set {
            context.themes = newValue
            setNeedsContextTraitUpdate()
        }
    }

    // MARK: Initialization

    /// Creates a root container that embeds the given child view controller.
    ///
    /// - Parameters:
    ///   - themes: Initial theme values. Defaults to an empty set.
    ///   - child: The view controller to embed as the single child.
    public init(themes : BThemes = .init(), child : UIViewController) {
        self.context = BContext(themes: themes)
        self.child = child
        super.init(nibName: nil, bundle: nil)
    }

    /// Creates a root container that hosts SwiftUI content.
    ///
    /// - Parameters:
    ///   - themes: Initial theme values. Defaults to an empty set.
    ///   - content: A SwiftUI view builder providing the root content.
    public convenience init<Content : View>(
        themes : BThemes = .init(),
        @ViewBuilder content : () -> Content
    ) {
        self.init(themes: themes, child: UIHostingController(rootView: content()))
    }

    @available(*, unavailable)
    required init?(coder : NSCoder) { fatalError() }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        addChild(child)
        child.view.frame = view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(child.view)
        child.didMove(toParent: self)

        context.traits.accessibility = .current()

        accessibilityObserver = BAccessibility.observeChanges { [weak self] _, new in
            guard let self else { return }
            self.context.traits.accessibility = new
            self.setNeedsContextTraitUpdate()
        }
        accessibilityObserver?.start()

        updateContextTraitIfNeeded()
    }

    // MARK: Private

    private let child : UIViewController

    private var accessibilityObserver : BAccessibility.Observer?

    private var needsContextTraitUpdate : Bool = true

    private func setNeedsContextTraitUpdate() {
        guard !needsContextTraitUpdate else { return }
        needsContextTraitUpdate = true

        RunLoop.main.perform { [weak self] in
            self?.updateContextTraitIfNeeded()
        }
    }

    private func updateContextTraitIfNeeded() {
        guard needsContextTraitUpdate else { return }
        needsContextTraitUpdate = false

        traitOverrides.bContext = context
    }
}

#endif

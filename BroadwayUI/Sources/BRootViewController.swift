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
    public private(set) var context : BContext {
        didSet {
            traitOverrides.bContext = context
        }
    }

    // MARK: Initialization

    /// Creates a root container that embeds the given child view controller.
    public init(child : UIViewController) {
        self.context = BContext()
        self.child = child

        super.init(nibName: nil, bundle: nil)

        addChild(child)
        child.didMove(toParent: self)

        context.traits.accessibility = .current()
        traitOverrides.bContext = context

        accessibilityObserver = BAccessibility.observeChanges { [weak self] _, new in
            guard let self else { return }
            self.context.traits.accessibility = new
        }
        accessibilityObserver?.start()
    }

    /// Creates a root container that hosts SwiftUI content.
    public convenience init<Content : View>(
        @ViewBuilder content : () -> Content
    ) {
        self.init(child: UIHostingController(rootView: content()))
    }

    @available(*, unavailable)
    required init?(coder : NSCoder) { fatalError() }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(child.view)
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        child.view.frame = view.bounds
    }

    // MARK: Private

    private let child : UIViewController

    private var accessibilityObserver : BAccessibility.Observer?
}

#endif

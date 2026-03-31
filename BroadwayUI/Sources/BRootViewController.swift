//
//  BRootViewController.swift
//  BroadwayUI
//

import BroadwayCore
import SwiftUI
import UIKit

/// A container view controller that owns the root ``BContext`` and
/// propagates it to all descendants via a custom `UITraitCollection` trait.
///
/// `BRootViewController` manages a ``BTraitsObserver``, keeping
/// ``BContext/traits`` in sync with system changes and re-publishing
/// the updated context through `traitOverrides`.
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
public final class BRootViewController: UIViewController {
    // MARK: Public

    /// The current context. Updated automatically when observed
    /// trait values change. Read this to inspect the live state.
    public private(set) var context: BContext {
        didSet {
            traitOverrides.bContext = context
        }
    }

    // MARK: Initialization

    /// Creates a root container that embeds the given child view controller.
    public init(child: UIViewController) {
        context = BContext(traits: .system)
        self.child = child

        super.init(nibName: nil, bundle: nil)

        addChild(child)
        child.didMove(toParent: self)

        traitsObserver = BTraitsObserver(traits: .system, from: self) { [weak self] traits in
            self?.context.traits = traits
        }
        context.traits = traitsObserver!.traits
        traitOverrides.bContext = context
    }

    /// Creates a root container that hosts SwiftUI content.
    public convenience init(
        @ViewBuilder content: () -> some View,
    ) {
        self.init(child: UIHostingController(rootView: content()))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    // MARK: Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        child.view.frame = view.bounds
        view.addSubview(child.view)

        traitsObserver?.start()
    }

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        child.view.frame = view.bounds
    }

    // MARK: Private

    private let child: UIViewController

    private var traitsObserver: BTraitsObserver?
}

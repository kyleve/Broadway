//
//  BContext+UITraits.swift
//  BroadwayCore
//

#if canImport(UIKit)

    import UIKit

    /// Bridges ``BContext`` into UIKit's trait system so that it propagates
    /// automatically through the view-controller and view hierarchy.
    struct BContextTrait: UITraitDefinition {
        static let defaultValue = BContext()
    }

    public extension UITraitCollection {
        /// The Broadway environment container carrying traits, themes,
        /// and the stylesheet cache. Inherited from the nearest ancestor
        /// that sets one; returns a default empty context otherwise.
        var bContext: BContext {
            self[BContextTrait.self]
        }
    }

    public extension UIMutableTraits {
        /// Gets or sets the ``BContext`` for this mutable traits collection.
        var bContext: BContext {
            get { self[BContextTrait.self] }
            set { self[BContextTrait.self] = newValue }
        }
    }

#endif

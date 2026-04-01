//
//  BTraitOverridesViewController.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/31/26.
//

import BroadwayCore
import Foundation
import UIKit

public final class BTraitOverridesViewController<Content: UIViewController>: UIViewController {
    public let content: Content
    public let overrides: (Context, inout BTraits.Overrides) -> Void

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    public init(
        _ content: () -> Content,
        overrides: @escaping (Context, inout BTraits.Overrides) -> Void,
    ) {
        self.content = content()
        self.overrides = overrides

        super.init()

        registerForTraitChanges(
            [BContextTrait.self],
            action: #selector(onTraitsDidChange(vc:previous:)),
        )
    }

    public convenience init<Value>(
        set keyPath: WritableKeyPath<BTraits.Overrides, Value>,
        to: Value,
        content: () -> Content,
    ) {
        self.init(content) { _, overrides in
            overrides[keyPath: keyPath] = to
        }
    }

    public struct Context {
        public let traits: BTraits
    }

    @objc private func onTraitsDidChange(
        vc _: UIViewController,
        previous _: UITraitCollection,
    ) {
        let original = traitCollection.bContext.traitOverrides
        var updated = original

        overrides(.init(traits: traitCollection.bContext.traits), &updated)

        if original != updated {
            // TODO: Does this actually work? I hope so, since context is
            // a struct, but not 100% sure. Hopefully each VC gets its own trait collection.
            traitOverrides.bContext.traitOverrides = updated
        }
    }
}

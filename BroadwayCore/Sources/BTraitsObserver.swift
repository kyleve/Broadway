//
//  BTraitsObserver.swift
//  BroadwayCore
//

import Foundation

/// Observes all registered ``BTraitsValue`` types, maintaining a
/// live ``BTraits`` snapshot and notifying the caller when any
/// trait changes.
///
/// Each ``BTraitsValue`` conformance declares its own
/// ``BTraitsValue/Observer`` and ``BTraitsValue/makeObserver(onChange:)``.
/// `BTraitsObserver` calls these generically and aggregates the
/// individual observers behind a single `start()` / `stop()` lifecycle.
@MainActor
public final class BTraitsObserver {
    // MARK: Public

    /// The current aggregated traits. Updated automatically when
    /// any observed trait value changes.
    public private(set) var traits: BTraits

    // MARK: Initialization

    /// - Parameter onChange: Called with the updated ``BTraits``
    ///   whenever any observed trait value changes.
    public init(
        onChange: @MainActor @escaping @Sendable (BTraits) -> Void,
    ) {
        traits = BTraits()
        self.onChange = onChange

        observe(BAccessibility.self)
    }

    // MARK: Lifecycle

    /// Starts all registered trait observers. Safe to call multiple times.
    public func start() {
        for observer in observers {
            observer.start()
        }
    }

    /// Stops all registered trait observers. Safe to call multiple times.
    public func stop() {
        for observer in observers {
            observer.stop()
        }
    }

    // MARK: Private

    private let onChange: @MainActor @Sendable (BTraits) -> Void
    private var observers: [any BTraitsValueObserver] = []

    private func observe<V: BTraitsValue>(_: V.Type) {
        traits[V.self] = V.initialValue

        let observer = V.makeObserver { [weak self] newValue in
            guard let self else { return }

            let old = traits
            traits[V.self] = newValue

            if traits != old {
                onChange(traits)
            }
        }

        observers.append(observer)
    }
}

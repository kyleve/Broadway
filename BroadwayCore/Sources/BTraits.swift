//
//  BTraits.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation

extension BTraits {
    public var accessibility: BAccessibility {
        get { self[BAccessibility.self] }
        set { self[BAccessibility.self] = newValue }
    }
}

extension BAccessibility: BTraitsValue {
    public static var defaultValue: Self {
        .init()
    }

    @MainActor public static var initialValue: BAccessibility {
        .current()
    }

    @MainActor public static func makeObserver(
        onChange: @MainActor @escaping @Sendable (BAccessibility) -> Void,
    ) -> BAccessibility.Observer {
        .init { _, new in onChange(new) }
    }
}

/// A type-keyed container of ``BTraitsValue`` conforming values
/// representing the current environment (accessibility, size classes, etc.).
///
/// Traits are always present; accessing a type that hasn't been explicitly
/// set returns its ``BTraitsValue/defaultValue``.
public struct BTraits: Equatable, Hashable, @unchecked Sendable {
    public init() {}

    /// Gets or sets the trait for the given type. Returns
    /// ``BTraitsValue/defaultValue`` if no value has been set.
    public subscript<Value: BTraitsValue>(_: Value.Type) -> Value {
        get {
            let id = TypeIdentifier(Value.self)

            guard let value = storage[id], let value = value.base as? Value else {
                return Value.defaultValue
            }

            return value
        }

        set {
            let id = TypeIdentifier(Value.self)

            storage[id] = AnyHashable(newValue)
        }
    }

    @CopyOnWrite private var storage: [TypeIdentifier: AnyHashable] = [:]
}

/// A hashable value that can be stored in ``BTraits``.
///
/// Conforming types provide a ``defaultValue`` that is returned when
/// the trait has not been explicitly set. Types that need live system
/// observation override ``initialValue`` and ``makeObserver(onChange:)``
/// to supply a snapshot and an observer.
public protocol BTraitsValue: Hashable {
    associatedtype Observer: BTraitsValueObserver = NeverObserver
    static var defaultValue: Self { get }
    @MainActor static var initialValue: Self { get }
    @MainActor static func makeObserver(
        onChange: @MainActor @escaping @Sendable (Self) -> Void,
    ) -> Observer
}

extension BTraitsValue {
    @MainActor public static var initialValue: Self {
        defaultValue
    }
}

extension BTraitsValue where Observer == NeverObserver {
    @MainActor public static func makeObserver(
        onChange _: @MainActor @escaping @Sendable (Self) -> Void,
    ) -> NeverObserver {
        NeverObserver()
    }
}

// MARK: - BTraitsValueObserver

/// The interface for an observer that monitors changes to
/// a single ``BTraitsValue`` type. Retained by ``BTraitsObserver``.
@MainActor public protocol BTraitsValueObserver: AnyObject {
    func start()
    func stop()
}

/// A no-op observer used as the default ``BTraitsValue/Observer``
/// for trait values that do not require live observation.
@MainActor public final class NeverObserver: BTraitsValueObserver {
    public init() {}
    public func start() {}
    public func stop() {}
}

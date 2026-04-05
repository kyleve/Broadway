@testable import BroadwayCore
import BroadwayTesting
import Testing
import UIKit

@MainActor
private final class CountingStartSpy: BTraitsValueObserver {
    weak static var lastInstance: CountingStartSpy?

    private(set) var startCount = 0

    init() {
        Self.lastInstance = self
    }

    func start() {
        startCount += 1
    }

    func stop() {}
}

private struct StartCountingTrait: BTraitsValue, Hashable {
    typealias Observer = CountingStartSpy

    @MainActor static var defaultValue: StartCountingTrait {
        StartCountingTrait()
    }

    @MainActor static func currentValue(from _: UIViewController) -> StartCountingTrait {
        StartCountingTrait()
    }

    @MainActor static func makeObserver(
        with _: UIViewController,
        onChange _: @MainActor @escaping @Sendable (StartCountingTrait) -> Void,
    ) -> CountingStartSpy {
        CountingStartSpy()
    }
}

@MainActor struct BTraitsObserverTests {
    private func makeSystemObserver(
        from viewController: UIViewController,
        onChange: @MainActor @escaping @Sendable (BTraits) -> Void = { _ in },
    ) -> BTraitsObserver {
        BTraitsObserver(traits: .system, from: viewController, onChange: onChange)
    }

    // MARK: - Initial Value

    @Test("Initial traits contain the live accessibility snapshot")
    func initialAccessibility() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            let observer = makeSystemObserver(from: hosted)
            #expect(observer.traits.accessibility == BAccessibility.current())
        }
    }

    @Test("Initial traits are not equal to a default BTraits()")
    func initialTraitsNotDefault() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            let observer = makeSystemObserver(from: hosted)
            let defaultTraits = BTraits()

            #expect(observer.traits.accessibility == BAccessibility.current())
            #expect(defaultTraits.accessibility == BAccessibility())
        }
    }

    // MARK: - Lifecycle

    @Test("start and stop complete without error")
    func startStop() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            let observer = makeSystemObserver(from: hosted)
            observer.start()
            observer.stop()
        }
    }

    @Test("Coordinator start is idempotent for underlying observers")
    func doubleStartForwardsStartOnceToObservers() throws {
        var traits = BTraits()
        traits.register(StartCountingTrait.self)

        let anchor = UIViewController()
        try show(anchor) { hosted in
            CountingStartSpy.lastInstance = nil
            let observer = BTraitsObserver(traits: traits, from: hosted, onChange: { _ in })
            observer.start()
            observer.start()
            #expect(CountingStartSpy.lastInstance?.startCount == 1)
            observer.stop()
        }
    }

    @Test("Calling stop without start is safe")
    func stopWithoutStart() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            let observer = makeSystemObserver(from: hosted)
            observer.stop()
        }
    }

    @Test("Calling stop twice is safe")
    func doubleStop() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            let observer = makeSystemObserver(from: hosted)
            observer.start()
            observer.stop()
            observer.stop()
        }
    }

    @Test("Can restart after stopping")
    func restart() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            let observer = makeSystemObserver(from: hosted)
            observer.start()
            observer.stop()
            observer.start()
            observer.stop()
        }
    }

    @Test("Deallocation after start does not crash")
    func deallocAfterStart() throws {
        let anchor = UIViewController()
        try show(anchor) { hosted in
            var observer: BTraitsObserver? = makeSystemObserver(from: hosted)
            observer?.start()
            observer = nil
            _ = observer
        }
    }
}

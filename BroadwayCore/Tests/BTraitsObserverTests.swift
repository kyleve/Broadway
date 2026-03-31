@testable import BroadwayCore
import Testing
import UIKit

@MainActor struct BTraitsObserverTests {
    private func makeObserver(
        onChange: @MainActor @escaping @Sendable (BTraits) -> Void = { _ in },
    ) -> BTraitsObserver {
        BTraitsObserver(traits: .system, from: UIViewController(), onChange: onChange)
    }

    // MARK: - Initial Value

    @Test("Initial traits contain the live accessibility snapshot")
    func initialAccessibility() {
        let observer = makeObserver()
        #expect(observer.traits.accessibility == BAccessibility.current())
    }

    @Test("Initial traits are not equal to a default BTraits()")
    func initialTraitsNotDefault() {
        let observer = makeObserver()
        let defaultTraits = BTraits()

        #expect(observer.traits.accessibility == BAccessibility.current())
        #expect(defaultTraits.accessibility == BAccessibility())
    }

    // MARK: - Lifecycle

    @Test("start and stop complete without error")
    func startStop() {
        let observer = makeObserver()
        observer.start()
        observer.stop()
    }

    @Test("Calling start twice is safe")
    func doubleStart() {
        let observer = makeObserver()
        observer.start()
        observer.start()
        observer.stop()
    }

    @Test("Calling stop without start is safe")
    func stopWithoutStart() {
        let observer = makeObserver()
        observer.stop()
    }

    @Test("Calling stop twice is safe")
    func doubleStop() {
        let observer = makeObserver()
        observer.start()
        observer.stop()
        observer.stop()
    }

    @Test("Can restart after stopping")
    func restart() {
        let observer = makeObserver()
        observer.start()
        observer.stop()
        observer.start()
        observer.stop()
    }

    @Test("Deallocation after start does not crash")
    func deallocAfterStart() {
        var observer: BTraitsObserver? = makeObserver()
        observer?.start()
        observer = nil
        _ = observer
    }
}

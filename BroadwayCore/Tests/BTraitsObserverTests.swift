@testable import BroadwayCore
import Testing

@MainActor struct BTraitsObserverTests {
    // MARK: - Initial Value

    @Test("Initial traits contain the live accessibility snapshot")
    func initialAccessibility() {
        let observer = BTraitsObserver { _ in }
        #expect(observer.traits.accessibility == BAccessibility.current())
    }

    @Test("Initial traits are not equal to a default BTraits()")
    func initialTraitsNotDefault() {
        let observer = BTraitsObserver { _ in }
        let defaultTraits = BTraits()

        #expect(observer.traits.accessibility == BAccessibility.current())
        #expect(defaultTraits.accessibility == BAccessibility())
    }

    // MARK: - Lifecycle

    @Test("start and stop complete without error")
    func startStop() {
        let observer = BTraitsObserver { _ in }
        observer.start()
        observer.stop()
    }

    @Test("Calling start twice is safe")
    func doubleStart() {
        let observer = BTraitsObserver { _ in }
        observer.start()
        observer.start()
        observer.stop()
    }

    @Test("Calling stop without start is safe")
    func stopWithoutStart() {
        let observer = BTraitsObserver { _ in }
        observer.stop()
    }

    @Test("Calling stop twice is safe")
    func doubleStop() {
        let observer = BTraitsObserver { _ in }
        observer.start()
        observer.stop()
        observer.stop()
    }

    @Test("Can restart after stopping")
    func restart() {
        let observer = BTraitsObserver { _ in }
        observer.start()
        observer.stop()
        observer.start()
        observer.stop()
    }

    @Test("Deallocation after start does not crash")
    func deallocAfterStart() {
        var observer: BTraitsObserver? = BTraitsObserver { _ in }
        observer?.start()
        observer = nil
        _ = observer
    }
}

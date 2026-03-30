@testable import BroadwayCore
import Foundation
import Testing

struct BAccessibilityTests {
    // MARK: - Default Initialization

    @Test("Default init sets all properties to false")
    func defaultInit() {
        let a = BAccessibility()

        #expect(a.buttonShapesEnabled == false)
        #expect(a.isAssistiveTouchRunning == false)
        #expect(a.isBoldTextEnabled == false)
        #expect(a.isClosedCaptioningEnabled == false)
        #expect(a.isDarkerSystemColorsEnabled == false)
        #expect(a.isGrayscaleEnabled == false)
        #expect(a.isGuidedAccessEnabled == false)
        #expect(a.isInvertColorsEnabled == false)
        #expect(a.isMonoAudioEnabled == false)
        #expect(a.isOnOffSwitchLabelsEnabled == false)
        #expect(a.isReduceMotionEnabled == false)
        #expect(a.isReduceTransparencyEnabled == false)
        #expect(a.isShakeToUndoEnabled == false)
        #expect(a.isSpeakScreenEnabled == false)
        #expect(a.isSpeakSelectionEnabled == false)
        #expect(a.isSwitchControlRunning == false)
        #expect(a.isVideoAutoplayEnabled == false)
        #expect(a.isVoiceOverRunning == false)
        #expect(a.prefersCrossFadeTransitions == false)
        #expect(a.shouldDifferentiateWithoutColor == false)
    }

    // MARK: - Per-Property Initialization

    @Test("Each property can be set individually", arguments: [
        \BAccessibility.buttonShapesEnabled,
        \BAccessibility.isAssistiveTouchRunning,
        \BAccessibility.isBoldTextEnabled,
        \BAccessibility.isClosedCaptioningEnabled,
        \BAccessibility.isDarkerSystemColorsEnabled,
        \BAccessibility.isGrayscaleEnabled,
        \BAccessibility.isGuidedAccessEnabled,
        \BAccessibility.isInvertColorsEnabled,
        \BAccessibility.isMonoAudioEnabled,
        \BAccessibility.isOnOffSwitchLabelsEnabled,
        \BAccessibility.isReduceMotionEnabled,
        \BAccessibility.isReduceTransparencyEnabled,
        \BAccessibility.isShakeToUndoEnabled,
        \BAccessibility.isSpeakScreenEnabled,
        \BAccessibility.isSpeakSelectionEnabled,
        \BAccessibility.isSwitchControlRunning,
        \BAccessibility.isVideoAutoplayEnabled,
        \BAccessibility.isVoiceOverRunning,
        \BAccessibility.prefersCrossFadeTransitions,
        \BAccessibility.shouldDifferentiateWithoutColor,
    ])
    func settingIndividualProperty(keyPath: WritableKeyPath<BAccessibility, Bool>) {
        var a = BAccessibility()
        a[keyPath: keyPath] = true

        #expect(a[keyPath: keyPath] == true)
        #expect(a != BAccessibility())
    }

    // MARK: - Equatable

    @Test("Two default instances are equal")
    func defaultEquality() {
        #expect(BAccessibility() == BAccessibility())
    }

    @Test("Instances with different values are not equal")
    func inequality() {
        let a = BAccessibility()
        let b = BAccessibility(isVoiceOverRunning: true)
        #expect(a != b)
    }

    @Test("Instances with identical non-default values are equal")
    func equalWithNonDefaults() {
        let a = BAccessibility(isBoldTextEnabled: true, isReduceMotionEnabled: true)
        let b = BAccessibility(isBoldTextEnabled: true, isReduceMotionEnabled: true)
        #expect(a == b)
    }

    // MARK: - Hashable

    @Test("Equal instances have the same hash")
    func equalHash() {
        let a = BAccessibility(isReduceMotionEnabled: true, isVoiceOverRunning: true)
        let b = BAccessibility(isReduceMotionEnabled: true, isVoiceOverRunning: true)
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Can be used as a Set element")
    func usableInSet() {
        let a = BAccessibility()
        let b = BAccessibility(isVoiceOverRunning: true)
        let set: Set<BAccessibility> = [a, b, a]
        #expect(set.count == 2)
    }

    // MARK: - Mutability

    @Test("Properties are mutable")
    func mutability() {
        var a = BAccessibility()
        a.isVoiceOverRunning = true
        a.isReduceMotionEnabled = true

        #expect(a.isVoiceOverRunning == true)
        #expect(a.isReduceMotionEnabled == true)

        a.isVoiceOverRunning = false
        #expect(a.isVoiceOverRunning == false)
    }
}

#if canImport(UIKit)

    import UIKit

    @MainActor struct BAccessibilityObserverTests {
        // MARK: - Factory

        @Test("observeChanges returns an Observer")
        func observeChangesFactory() {
            let observer = BAccessibility.observeChanges { _, _ in }
            _ = observer
        }

        // MARK: - Lifecycle

        @Test("start and stop complete without error")
        func startStop() {
            let observer = BAccessibility.Observer { _, _ in }
            observer.start()
            observer.stop()
        }

        @Test("Calling start twice is safe")
        func doubleStart() {
            let observer = BAccessibility.Observer { _, _ in }
            observer.start()
            observer.start()
            observer.stop()
        }

        @Test("Calling stop without start is safe")
        func stopWithoutStart() {
            let observer = BAccessibility.Observer { _, _ in }
            observer.stop()
        }

        @Test("Calling stop twice is safe")
        func doubleStop() {
            let observer = BAccessibility.Observer { _, _ in }
            observer.start()
            observer.stop()
            observer.stop()
        }

        @Test("Can restart after stopping")
        func restart() {
            let observer = BAccessibility.Observer { _, _ in }
            observer.start()
            observer.stop()
            observer.start()
            observer.stop()
        }

        @Test("Deallocation after start does not crash")
        func deallocAfterStart() {
            var observer: BAccessibility.Observer? = BAccessibility.Observer { _, _ in }
            observer?.start()
            observer = nil
            _ = observer
        }

        // MARK: - Injected NotificationCenter

        @Test("Observer registers for all expected notifications on start")
        func registersOnStart() {
            let center = NotificationCenter()

            let observer = BAccessibility.Observer(notificationCenter: center) { _, _ in }
            observer.start()

            // Post through injected center — observer should receive it without
            // interfering with the default center.
            center.post(name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)

            observer.stop()
        }

        @Test("Observer does not respond to notifications from the default center when injected")
        func isolatedFromDefault() {
            let center = NotificationCenter()
            var callCount = 0

            let observer = BAccessibility.Observer(notificationCenter: center) { _, _ in
                callCount += 1
            }
            observer.start()

            NotificationCenter.default.post(
                name: UIAccessibility.voiceOverStatusDidChangeNotification,
                object: nil,
            )

            #expect(callCount == 0)

            observer.stop()
        }

        @Test("Stop removes registrations from the injected center")
        func stopRemovesFromInjected() {
            let center = NotificationCenter()
            var callCount = 0

            let observer = BAccessibility.Observer(notificationCenter: center) { _, _ in
                callCount += 1
            }
            observer.start()
            observer.stop()

            center.post(name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)

            #expect(callCount == 0)
        }

        @Test("observeChanges factory passes injected center through")
        func factoryPassesCenter() {
            let center = NotificationCenter()
            var callCount = 0

            let observer = BAccessibility.observeChanges(notificationCenter: center) { _, _ in
                callCount += 1
            }
            observer.start()

            NotificationCenter.default.post(
                name: UIAccessibility.voiceOverStatusDidChangeNotification,
                object: nil,
            )

            #expect(callCount == 0)

            observer.stop()
        }

        // MARK: - Notification Behavior

        @Test("Does not fire onChange when accessibility state has not changed")
        func noSpuriousCallback() {
            let center = NotificationCenter()
            var callCount = 0

            let observer = BAccessibility.Observer(notificationCenter: center) { _, _ in
                callCount += 1
            }
            observer.start()

            center.post(
                name: UIAccessibility.voiceOverStatusDidChangeNotification,
                object: nil,
            )

            #expect(callCount == 0)

            observer.stop()
        }

        @Test("Does not fire onChange after stop")
        func noCallbackAfterStop() {
            let center = NotificationCenter()
            var callCount = 0

            let observer = BAccessibility.Observer(notificationCenter: center) { _, _ in
                callCount += 1
            }
            observer.start()
            observer.stop()

            center.post(
                name: UIAccessibility.voiceOverStatusDidChangeNotification,
                object: nil,
            )

            #expect(callCount == 0)
        }
    }

#endif

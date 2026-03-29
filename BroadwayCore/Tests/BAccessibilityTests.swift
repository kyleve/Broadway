import Testing
@testable import BroadwayCore


@Suite("BAccessibility")
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

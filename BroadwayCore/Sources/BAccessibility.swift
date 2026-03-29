//
//  BAccessibility.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/29/26.
//

import Foundation


public struct BAccessibility : Equatable, Hashable {

    // MARK: Assistive Technologies

    public var isVoiceOverRunning: Bool
    public var isSwitchControlRunning: Bool
    public var isAssistiveTouchRunning: Bool
    public var isGuidedAccessEnabled: Bool

    // MARK: Vision

    public var isBoldTextEnabled: Bool
    public var isGrayscaleEnabled: Bool
    public var isInvertColorsEnabled: Bool
    public var isDarkerSystemColorsEnabled: Bool
    public var isReduceTransparencyEnabled: Bool
    public var shouldDifferentiateWithoutColor: Bool
    public var isOnOffSwitchLabelsEnabled: Bool
    public var buttonShapesEnabled: Bool

    // MARK: Motion

    public var isReduceMotionEnabled: Bool
    public var prefersCrossFadeTransitions: Bool
    public var isVideoAutoplayEnabled: Bool

    // MARK: Audio & Speech

    public var isMonoAudioEnabled: Bool
    public var isClosedCaptioningEnabled: Bool
    public var isSpeakScreenEnabled: Bool
    public var isSpeakSelectionEnabled: Bool

    // MARK: Other

    public var isShakeToUndoEnabled: Bool

    // MARK: Initialization

    public init(
        isVoiceOverRunning: Bool = false,
        isSwitchControlRunning: Bool = false,
        isAssistiveTouchRunning: Bool = false,
        isGuidedAccessEnabled: Bool = false,
        isBoldTextEnabled: Bool = false,
        isGrayscaleEnabled: Bool = false,
        isInvertColorsEnabled: Bool = false,
        isDarkerSystemColorsEnabled: Bool = false,
        isReduceTransparencyEnabled: Bool = false,
        shouldDifferentiateWithoutColor: Bool = false,
        isOnOffSwitchLabelsEnabled: Bool = false,
        buttonShapesEnabled: Bool = false,
        isReduceMotionEnabled: Bool = false,
        prefersCrossFadeTransitions: Bool = false,
        isVideoAutoplayEnabled: Bool = false,
        isMonoAudioEnabled: Bool = false,
        isClosedCaptioningEnabled: Bool = false,
        isSpeakScreenEnabled: Bool = false,
        isSpeakSelectionEnabled: Bool = false,
        isShakeToUndoEnabled: Bool = false
    ) {
        self.isVoiceOverRunning = isVoiceOverRunning
        self.isSwitchControlRunning = isSwitchControlRunning
        self.isAssistiveTouchRunning = isAssistiveTouchRunning
        self.isGuidedAccessEnabled = isGuidedAccessEnabled
        self.isBoldTextEnabled = isBoldTextEnabled
        self.isGrayscaleEnabled = isGrayscaleEnabled
        self.isInvertColorsEnabled = isInvertColorsEnabled
        self.isDarkerSystemColorsEnabled = isDarkerSystemColorsEnabled
        self.isReduceTransparencyEnabled = isReduceTransparencyEnabled
        self.shouldDifferentiateWithoutColor = shouldDifferentiateWithoutColor
        self.isOnOffSwitchLabelsEnabled = isOnOffSwitchLabelsEnabled
        self.buttonShapesEnabled = buttonShapesEnabled
        self.isReduceMotionEnabled = isReduceMotionEnabled
        self.prefersCrossFadeTransitions = prefersCrossFadeTransitions
        self.isVideoAutoplayEnabled = isVideoAutoplayEnabled
        self.isMonoAudioEnabled = isMonoAudioEnabled
        self.isClosedCaptioningEnabled = isClosedCaptioningEnabled
        self.isSpeakScreenEnabled = isSpeakScreenEnabled
        self.isSpeakSelectionEnabled = isSpeakSelectionEnabled
        self.isShakeToUndoEnabled = isShakeToUndoEnabled
    }
}


#if canImport(UIKit)

import UIKit

extension BAccessibility {

    public static func current() -> BAccessibility {
        BAccessibility(
            isVoiceOverRunning: UIAccessibility.isVoiceOverRunning,
            isSwitchControlRunning: UIAccessibility.isSwitchControlRunning,
            isAssistiveTouchRunning: UIAccessibility.isAssistiveTouchRunning,
            isGuidedAccessEnabled: UIAccessibility.isGuidedAccessEnabled,
            isBoldTextEnabled: UIAccessibility.isBoldTextEnabled,
            isGrayscaleEnabled: UIAccessibility.isGrayscaleEnabled,
            isInvertColorsEnabled: UIAccessibility.isInvertColorsEnabled,
            isDarkerSystemColorsEnabled: UIAccessibility.isDarkerSystemColorsEnabled,
            isReduceTransparencyEnabled: UIAccessibility.isReduceTransparencyEnabled,
            shouldDifferentiateWithoutColor: UIAccessibility.shouldDifferentiateWithoutColor,
            isOnOffSwitchLabelsEnabled: UIAccessibility.isOnOffSwitchLabelsEnabled,
            buttonShapesEnabled: UIAccessibility.buttonShapesEnabled,
            isReduceMotionEnabled: UIAccessibility.isReduceMotionEnabled,
            prefersCrossFadeTransitions: UIAccessibility.prefersCrossFadeTransitions,
            isVideoAutoplayEnabled: UIAccessibility.isVideoAutoplayEnabled,
            isMonoAudioEnabled: UIAccessibility.isMonoAudioEnabled,
            isClosedCaptioningEnabled: UIAccessibility.isClosedCaptioningEnabled,
            isSpeakScreenEnabled: UIAccessibility.isSpeakScreenEnabled,
            isSpeakSelectionEnabled: UIAccessibility.isSpeakSelectionEnabled,
            isShakeToUndoEnabled: UIAccessibility.isShakeToUndoEnabled
        )
    }
}

#endif

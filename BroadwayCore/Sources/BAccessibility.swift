//
//  BAccessibility.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/29/26.
//

import Foundation

/// A snapshot of the device's current accessibility settings.
///
/// Each property mirrors a corresponding `UIAccessibility` class property.
/// Use ``current()`` to read the live system state, or construct
/// instances directly for testing and previews.
public struct BAccessibility: Equatable, Hashable, Sendable {
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
        buttonShapesEnabled: Bool = false,
        isAssistiveTouchRunning: Bool = false,
        isBoldTextEnabled: Bool = false,
        isClosedCaptioningEnabled: Bool = false,
        isDarkerSystemColorsEnabled: Bool = false,
        isGrayscaleEnabled: Bool = false,
        isGuidedAccessEnabled: Bool = false,
        isInvertColorsEnabled: Bool = false,
        isMonoAudioEnabled: Bool = false,
        isOnOffSwitchLabelsEnabled: Bool = false,
        isReduceMotionEnabled: Bool = false,
        isReduceTransparencyEnabled: Bool = false,
        isShakeToUndoEnabled: Bool = false,
        isSpeakScreenEnabled: Bool = false,
        isSpeakSelectionEnabled: Bool = false,
        isSwitchControlRunning: Bool = false,
        isVideoAutoplayEnabled: Bool = false,
        isVoiceOverRunning: Bool = false,
        prefersCrossFadeTransitions: Bool = false,
        shouldDifferentiateWithoutColor: Bool = false,
    ) {
        self.buttonShapesEnabled = buttonShapesEnabled
        self.isAssistiveTouchRunning = isAssistiveTouchRunning
        self.isBoldTextEnabled = isBoldTextEnabled
        self.isClosedCaptioningEnabled = isClosedCaptioningEnabled
        self.isDarkerSystemColorsEnabled = isDarkerSystemColorsEnabled
        self.isGrayscaleEnabled = isGrayscaleEnabled
        self.isGuidedAccessEnabled = isGuidedAccessEnabled
        self.isInvertColorsEnabled = isInvertColorsEnabled
        self.isMonoAudioEnabled = isMonoAudioEnabled
        self.isOnOffSwitchLabelsEnabled = isOnOffSwitchLabelsEnabled
        self.isReduceMotionEnabled = isReduceMotionEnabled
        self.isReduceTransparencyEnabled = isReduceTransparencyEnabled
        self.isShakeToUndoEnabled = isShakeToUndoEnabled
        self.isSpeakScreenEnabled = isSpeakScreenEnabled
        self.isSpeakSelectionEnabled = isSpeakSelectionEnabled
        self.isSwitchControlRunning = isSwitchControlRunning
        self.isVideoAutoplayEnabled = isVideoAutoplayEnabled
        self.isVoiceOverRunning = isVoiceOverRunning
        self.prefersCrossFadeTransitions = prefersCrossFadeTransitions
        self.shouldDifferentiateWithoutColor = shouldDifferentiateWithoutColor
    }
}

#if canImport(UIKit)

    import UIKit

    public extension BAccessibility {
        /// Returns a snapshot of the current device accessibility settings
        /// by reading each `UIAccessibility` class property.
        static func current() -> BAccessibility {
            BAccessibility(
                buttonShapesEnabled: UIAccessibility.buttonShapesEnabled,
                isAssistiveTouchRunning: UIAccessibility.isAssistiveTouchRunning,
                isBoldTextEnabled: UIAccessibility.isBoldTextEnabled,
                isClosedCaptioningEnabled: UIAccessibility.isClosedCaptioningEnabled,
                isDarkerSystemColorsEnabled: UIAccessibility.isDarkerSystemColorsEnabled,
                isGrayscaleEnabled: UIAccessibility.isGrayscaleEnabled,
                isGuidedAccessEnabled: UIAccessibility.isGuidedAccessEnabled,
                isInvertColorsEnabled: UIAccessibility.isInvertColorsEnabled,
                isMonoAudioEnabled: UIAccessibility.isMonoAudioEnabled,
                isOnOffSwitchLabelsEnabled: UIAccessibility.isOnOffSwitchLabelsEnabled,
                isReduceMotionEnabled: UIAccessibility.isReduceMotionEnabled,
                isReduceTransparencyEnabled: UIAccessibility.isReduceTransparencyEnabled,
                isShakeToUndoEnabled: UIAccessibility.isShakeToUndoEnabled,
                isSpeakScreenEnabled: UIAccessibility.isSpeakScreenEnabled,
                isSpeakSelectionEnabled: UIAccessibility.isSpeakSelectionEnabled,
                isSwitchControlRunning: UIAccessibility.isSwitchControlRunning,
                isVideoAutoplayEnabled: UIAccessibility.isVideoAutoplayEnabled,
                isVoiceOverRunning: UIAccessibility.isVoiceOverRunning,
                prefersCrossFadeTransitions: UIAccessibility.prefersCrossFadeTransitions,
                shouldDifferentiateWithoutColor: UIAccessibility.shouldDifferentiateWithoutColor,
            )
        }
    }

    public extension BAccessibility {
        /// Keeps a ``BContext``'s accessibility traits in sync with the device
        /// by delivering change notifications as `(old, new)` pairs.
        ///
        /// Retain the returned ``Observer`` for the duration of observation.
        /// Call ``Observer/start()`` to begin and ``Observer/stop()`` to pause.
        ///
        /// - Parameter onChange: Called with `(old, new)` values when a change is detected.
        /// - Returns: An ``Observer`` that must be retained for the lifetime of observation.
        @MainActor static func observeChanges(
            _ onChange: @MainActor @escaping @Sendable (BAccessibility, BAccessibility) -> Void,
        ) -> Observer {
            Observer(onChange: onChange)
        }

        /// Manages `NotificationCenter` registrations for system accessibility
        /// changes and reports diffs via a callback.
        /// Call ``start()`` and ``stop()`` to control the observation lifecycle.
        /// Automatically unregisters on deallocation.
        @MainActor
        final class Observer {
            private let onChange: @MainActor @Sendable (BAccessibility, BAccessibility) -> Void

            private var old: BAccessibility?

            private var isObserving: Bool = false

            public init(onChange: @MainActor @escaping @Sendable (BAccessibility, BAccessibility) -> Void) {
                self.onChange = onChange
                old = nil
            }

            deinit {
                for name in Self.notifications {
                    NotificationCenter.default.removeObserver(self, name: name, object: nil)
                }
            }

            /// Begins observing accessibility changes. Safe to call multiple times;
            /// subsequent calls while already observing are no-ops.
            public func start() {
                guard !isObserving else { return }

                isObserving = true
                old = .current()

                for name in Self.notifications {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(accessibilityDidChange(_:)),
                        name: name,
                        object: nil,
                    )
                }
            }

            /// Stops observing accessibility changes and removes all notification
            /// registrations. Safe to call multiple times or before ``start()``.
            public func stop() {
                guard isObserving else { return }

                isObserving = false

                for name in Self.notifications {
                    NotificationCenter.default.removeObserver(self, name: name, object: nil)
                }

                old = nil
            }

            @objc private func accessibilityDidChange(_: Notification) {
                let new = BAccessibility.current()

                guard let old, old != new else { return }

                self.old = new
                onChange(old, new)
            }

            private static let notifications: [Notification.Name] = [
                UIAccessibility.assistiveTouchStatusDidChangeNotification,
                UIAccessibility.boldTextStatusDidChangeNotification,
                UIAccessibility.buttonShapesEnabledStatusDidChangeNotification,
                UIAccessibility.closedCaptioningStatusDidChangeNotification,
                UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
                UIAccessibility.differentiateWithoutColorDidChangeNotification,
                UIAccessibility.grayscaleStatusDidChangeNotification,
                UIAccessibility.guidedAccessStatusDidChangeNotification,
                UIAccessibility.invertColorsStatusDidChangeNotification,
                UIAccessibility.monoAudioStatusDidChangeNotification,
                UIAccessibility.onOffSwitchLabelsDidChangeNotification,
                UIAccessibility.prefersCrossFadeTransitionsStatusDidChange,
                UIAccessibility.reduceMotionStatusDidChangeNotification,
                UIAccessibility.reduceTransparencyStatusDidChangeNotification,
                UIAccessibility.shakeToUndoDidChangeNotification,
                UIAccessibility.speakScreenStatusDidChangeNotification,
                UIAccessibility.speakSelectionStatusDidChangeNotification,
                UIAccessibility.switchControlStatusDidChangeNotification,
                UIAccessibility.videoAutoplayStatusDidChangeNotification,
                UIAccessibility.voiceOverStatusDidChangeNotification,
            ]
        }
    }

#endif

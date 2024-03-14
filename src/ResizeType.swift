import Foundation
import SwiftUI

enum ResizeTypeBasic: String, Codable, CaseIterable {
    case toLeftSide = "Left Side",
    toRightSide = "Right Side",
    toCenter = "Center"

    var type: String {
        switch self {
            case .toLeftSide:
                return "toLeftSide"
            case .toRightSide:
                return "toRightSide"
            case .toCenter:
                return "toCenter"
        }
    }
}

enum ResizeType: String, Codable, CaseIterable {
    case toLeftSide = "Left Side",
    toRightSide = "Right Side",
    toTopLeft = "Top Left Corner",
    toTopRight = "Top Right Corner",
    toBottomLeft = "Bottom Left Corner",
    toBottomRight = "Bottom Right Corner",
    toCenter = "Center",
    maximize = "Maximize"

    func isBasic(_ name: Self) -> Bool {
        switch self {
            case .toLeftSide, .toRightSide, .toCenter, .maximize:
                return true
            default:
                return false
        }
    }

    var key: KeyEquivalent {
        switch self {
            case .toLeftSide:
                return KeyEquivalent.leftArrow
            case .toRightSide:
                return KeyEquivalent.rightArrow
            case .toTopLeft:
                return KeyEquivalent.upArrow
            case .toTopRight:
                return KeyEquivalent.upArrow
            case .toBottomLeft:
                return KeyEquivalent.downArrow
            case .toBottomRight:
                return KeyEquivalent.downArrow
            case .toCenter:
                return "a"
            case .maximize:
                return "d"
        }
    }

    var modifiers: EventModifiers {
        switch self {
            case .toLeftSide:
                return [EventModifiers.command]
            case .toRightSide:
                return [EventModifiers.command]
            case .toTopLeft:
                return [EventModifiers.command, EventModifiers.option]
            case .toTopRight:
                return [EventModifiers.command, EventModifiers.option]
            case .toBottomLeft:
                return [EventModifiers.command, EventModifiers.option]
            case .toBottomRight:
                return [EventModifiers.command, EventModifiers.option]
            case .toCenter:
                return [EventModifiers.command]
            case .maximize:
                return [EventModifiers.command]
        }
    }

    var type: String {
        switch self {
            case .toLeftSide:
                return "toLeftSide"
            case .toRightSide:
                return "toRightSide"
            case .toTopLeft:
                return "toTopLeftSide"
            case .toTopRight:
                return "toTopRightSide"
            case .toBottomLeft:
                return "toBottomLeftSide"
            case .toBottomRight:
                return "toBottomRightSide"
            case .toCenter:
                return "toCenter"
            case .maximize:
                return "maximize"
        }
    }
}

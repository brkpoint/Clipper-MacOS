import Foundation
import SwiftUI
import KeyboardShortcuts

enum ResizeType: String, Codable, CaseIterable {
    case toLeftSide = "Left Side",
    toRightSide = "Right Side",
    toTopLeft = "Top Left Corner",
    toTopRight = "Top Right Corner",
    toBottomLeft = "Bottom Left Corner",
    toBottomRight = "Bottom Right Corner",
    toCenter = "Center",
    maximize = "Maximize",
    centerQuarterSize = "Center Quarter"

    func isBasic(_ name: Self) -> Bool {
        switch self {
            case .toLeftSide, .toRightSide, .toCenter, .maximize:
                return true
            default:
                return false
        }
    }

    var key: KeyboardShortcuts.Key {
        switch self {
            case .toLeftSide:
                return .leftBracket
            case .toRightSide:
                return .rightBracket
            case .toTopLeft:
                return .semicolon
            case .toTopRight:
                return .quote
            case .toBottomLeft:
                return .comma
            case .toBottomRight:
                return .period
            case .toCenter:
                return .p
            case .maximize:
                return .l
            case .centerQuarterSize:
                return .k
        }
    }

    var modifiers: NSEvent.ModifierFlags {
        switch self {
            case .toLeftSide:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .toRightSide:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .toTopLeft:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .toTopRight:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .toBottomLeft:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .toBottomRight:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .toCenter:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .maximize:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
            case .centerQuarterSize:
                return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]

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
            case .centerQuarterSize:
                return "centerQuarterSize"
        }
    }
}

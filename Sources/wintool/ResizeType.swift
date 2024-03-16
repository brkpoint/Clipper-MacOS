import Foundation
import SwiftUI
import HotKey

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

    var key: Key {
        switch self {
            case .toLeftSide:
                return Key.leftBracket
            case .toRightSide:
                return Key.rightBracket
            case .toTopLeft:
                return Key.semicolon
            case .toTopRight:
                return Key.quote
            case .toBottomLeft:
                return Key.comma
            case .toBottomRight:
                return Key.period
            case .toCenter:
                return Key.p
            case .maximize:
                return Key.l
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

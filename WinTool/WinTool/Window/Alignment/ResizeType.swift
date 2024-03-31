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
    centerQuarterSize = "Center Quarter",
    snap = "Snap Button"

    func isBasic(_ name: Self) -> Bool {
        switch self {
            case .toLeftSide, .toRightSide, .toCenter, .maximize:
                return true
            default:
                return false
        }
    }
    
    func execute(_ name: Self) {
        switch self {
            case .snap:
            SnappingManager.shared.fire()
                break
            default:
                WindowManager.shared.Align(self)
                break
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
            case .snap:
                return .backtick
        }
    }

    var modifiers: NSEvent.ModifierFlags {
        switch self {
            case .snap:
                return [NSEvent.ModifierFlags.command]
            default:
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
            case .snap:
                return "snap"
        }
    }
}

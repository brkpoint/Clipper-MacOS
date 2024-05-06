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

    func isBasic() -> Bool {
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
        return [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.control]
    }
    
    func rect(_ application: WindowElement) -> CGRect? {
        let screen: NSScreen = Screen.shared.screen
        switch self {
            case .toLeftSide:
                return CGRect(x: 0, 
                              y: 0,
                              width: screen.frame.width / 2, 
                              height: screen.frame.height)
            case .toRightSide:
                return CGRect(x: screen.frame.width / 2, 
                              y: 0,
                              width: screen.frame.width / 2,
                              height: screen.frame.height)
            case .toTopLeft:
                return CGRect(x: 0, 
                              y: 0,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toTopRight:
                return CGRect(x: screen.frame.width / 2, 
                              y: 0, 
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toBottomLeft:
                return CGRect(x: 0, 
                              y: screen.frame.height / 2,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toBottomRight:
                return CGRect(x: screen.frame.width / 2, 
                              y: screen.frame.height / 2,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toCenter:
                return CGRect(x: screen.frame.width / 2 - application.frame.width / 2, 
                              y: screen.frame.height / 2 - application.frame.height / 2,
                              width: application.frame.width,
                              height: application.frame.height)
            case .maximize:
                return CGRect(x: 0, 
                              y: 0,
                              width: screen.frame.width,
                              height: screen.frame.height)
            case .centerQuarterSize:
                return CGRect(x: screen.frame.width / 2 - screen.frame.width / 4,
                              y: screen.frame.midY - screen.frame.height / 4,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
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

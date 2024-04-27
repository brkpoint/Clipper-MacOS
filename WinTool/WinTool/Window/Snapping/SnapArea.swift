import Foundation
import SwiftUI
import KeyboardShortcuts

enum SnapArea: String, Codable, CaseIterable {
    case toTopLeft = "Top Left Corner",
    toTopRight = "Top Right Corner",
    toBottomLeft = "Bottom Left Corner",
    toBottomRight = "Bottom Right Corner"
    
    var resizeType: ResizeType {
        switch self {
            case .toTopLeft:
                return ResizeType.toTopLeft
            case .toTopRight:
                return ResizeType.toTopRight
            case .toBottomLeft:
                return ResizeType.toBottomLeft
            case .toBottomRight:
                return ResizeType.toBottomRight
        }
    }
    
    func rect(_ application: WindowElement) -> CGRect? {
        let screen: NSScreen = ScreenManager.shared.GetScreen()
        switch self {
            case .toTopLeft:
                return ResizeType.toTopLeft.rect(application)
            case .toTopRight:
                return ResizeType.toTopRight.rect(application)
            case .toBottomLeft:
                return ResizeType.toBottomLeft.rect(application)
            case .toBottomRight:
                return ResizeType.toBottomRight.rect(application)
        }
    }
    
    func overlayRect(_ application: WindowElement) -> CGRect? {
        let screen: NSScreen = ScreenManager.shared.GetScreen()
        switch self {
            case .toTopLeft:
                return CGRect(x: 5,
                              y: screen.frame.height / 2 - 31,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toTopRight:
                return CGRect(x: screen.frame.width / 2 - 5,
                              y: screen.frame.height / 2 - 31,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toBottomLeft:
                return CGRect(x: 5,
                              y: 5,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
            case .toBottomRight:
                return CGRect(x: screen.frame.width / 2 - 5,
                              y: 5,
                              width: screen.frame.width / 2,
                              height: screen.frame.height / 2)
        }
    }
    
    var type: String {
        switch self {
            case .toTopLeft:
                return "toTopLeftSide"
            case .toTopRight:
                return "toTopRightSide"
            case .toBottomLeft:
                return "toBottomLeftSide"
            case .toBottomRight:
                return "toBottomRightSide"
        }
    }
}

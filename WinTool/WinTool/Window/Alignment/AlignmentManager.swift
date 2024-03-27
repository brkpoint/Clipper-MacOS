import Foundation
import Cocoa
import SwiftUI

struct AligmentManager {
    func AlignFrame(_ type: ResizeType, _ screen: NSScreen?, _ currentApplication: WindowElement) {
        let screenFrame: CGRect? = screen?.visibleFrame

        let screenWidth: CGFloat = screenFrame?.width ?? 1600
        let screenHeight: CGFloat = screenFrame?.height ?? 1200

        var frame: CGRect {
            switch type {
                case ResizeType.toLeftSide:
                    return CGRect(x: 0, y: 0, width: screenWidth / 2 as CGFloat, height: screenHeight as CGFloat)
                case ResizeType.toRightSide:
                    return CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2 as CGFloat, height: screenHeight as CGFloat)
                case ResizeType.toCenter:
                    return CGRect(x: screenWidth / 2 - currentApplication.frame.width / 2,
                                 y: screenHeight / 2 - currentApplication.frame.height / 2,
                                 width: currentApplication.frame.width,
                                 height: currentApplication.frame.height
                                 )
                case ResizeType.maximize:
                    return CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                case ResizeType.toBottomLeft:
                    return CGRect(x: 0, y: screenHeight / 2, width: screenWidth / 2, height: screenHeight / 2)
                case ResizeType.toBottomRight:
                    return CGRect(x: screenWidth / 2, y: screenHeight / 2, width: screenWidth / 2, height: screenHeight / 2)
                case ResizeType.toTopLeft:
                    return CGRect(x: 0, y: 0, width: screenWidth / 2, height: screenHeight / 2)
                case ResizeType.toTopRight:
                    return CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2, height: screenHeight / 2)
                case ResizeType.centerQuarterSize:
                    return CGRect(x: screenWidth / 2 - screenWidth / 4,
                                 y: screenHeight / 2 - screenHeight / 4,
                                 width: screenHeight / 4,
                                 height: screenHeight / 4
                                 )
            }
        }

        currentApplication.setFrame(frame)
    }
}

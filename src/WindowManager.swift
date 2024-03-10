import Cocoa
import SwiftUI

class WindowManager {
    // enum AlingOptions: Int {
    //     case toLeft = 0,
    //     toRight = 1,
    //     toTopLeft = 2,
    //     toTopRight = 3,
    //     toBottomLeft = 4,
    //     toBottomRight = 5,
    //     toCenter = 6,
    //     toTop = 7,
    //     toBottom = 8
    // }

    func Align(_ type: ResizeType) {
        print(type)
    }

    func Align(_ type: ResizeTypeBasic) {
        print(type)
    }

    func GetCurrentApp() -> WindowElement {
        return WindowElement("Test")
    }

}

import Cocoa
import SwiftUI

public class WindowManager {
    static let shared = WindowManager()

    private(set) var currentApplication: WindowElement
    private init() {
        currentApplication = WindowElement("", "")
    }

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

    func SetApp(_ app: WindowElement) {
        currentApplication = app
    }

    func Align(_ type: ResizeType) {
        print(type)
    }

    func GetCurrentApp() -> WindowElement {
        return currentApplication
    }

}

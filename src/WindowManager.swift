import Cocoa
import SwiftUI

public class WindowManager {
    static let shared = WindowManager()

    private(set) var currentApplication: WindowElement
    
    private init() {
        currentApplication = WindowElement("", "", pid_t(0))
    }

    func SetApp(_ app: WindowElement) {
        currentApplication = app
    }

    func Align(_ type: ResizeType) {
        currentApplication.setFrame(CGRect.init(x: 0, y: 0, width: 800, height: 600))
    }

    func GetCurrentApp() -> WindowElement {
        return currentApplication
    }

}

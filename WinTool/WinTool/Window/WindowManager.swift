import Cocoa
import SwiftUI

public class WindowManager {
    static let shared = WindowManager()
    
    private var screen = NSScreen.main
    private(set) var currentApplication: WindowElement = WindowElement("", "", pid_t(0))

    func SetApp(_ app: WindowElement) {
        print("INFO: Updating the window to \(app.name)")
        currentApplication = app
        screen = NSScreen.main
    }

    func Align(_ type: ResizeType) {
        AlignmentManager.shared.AlignFrame(type, currentApplication)
    }

    func GetCurrentApp() -> WindowElement {
        return currentApplication
    }
}

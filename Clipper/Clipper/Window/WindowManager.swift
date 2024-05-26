import Cocoa
import SwiftUI

public class WindowManager {
    static let shared = WindowManager()
    
    private(set) var application: WindowElement = WindowElement("", "", nil)

    func SetApp(_ app: WindowElement) {
        print("INFO: Updating the app to \(app.name)")
        application = app
    }

    func Align(_ type: ResizeType) {
        AlignmentManager.shared.AlignFrame(type, application)
    }
}

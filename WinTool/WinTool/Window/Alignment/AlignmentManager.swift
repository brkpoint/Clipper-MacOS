import Foundation
import Cocoa
import SwiftUI

class AlignmentManager {
    static var shared: AlignmentManager = AlignmentManager()
    
    func AlignFrame(_ type: ResizeType, _ currentApplication: WindowElement) {
        let screenFrame: CGRect? = ScreenManager.shared.GetScreen().frame
        
        if let rect = type.rect(currentApplication) {
            currentApplication.setFrame(rect)
        }
    }
}

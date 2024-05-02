import Foundation
import Cocoa
import SwiftUI

class AlignmentManager {
    static var shared: AlignmentManager = AlignmentManager()
    
    func AlignFrame(_ type: ResizeType, _ currentApplication: WindowElement) {
        guard let rect = type.rect(currentApplication) else { return }
        
        currentApplication.setFrame(rect)
    }
}

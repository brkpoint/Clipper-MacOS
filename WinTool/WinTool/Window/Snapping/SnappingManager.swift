import Foundation
import SwiftUI
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    func addMouseEventMonitor() {
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .otherMouseDragged]) { event in
            if !(SettingsManager.shared.snappingEnabled.value as? Bool ?? true) {
                return
            }
            
            //event.window?.mouseLocationOutsideOfEventStream
            
            // to do
        }
    }
    
    private func checkBoundingBox(_ position: NSPoint, _ box: CGRect) {
        
    }
}

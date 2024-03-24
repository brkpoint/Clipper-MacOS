import Foundation
import SwiftUI
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    public func addMouseEventMonitor() {
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged, .otherMouseDragged]) { event in
            if !(SettingsManager.shared.snappingEnabled.value as? Bool ?? true) {
                return
            }
            
            // to do
        }
    }
}

import Foundation
import SwiftUI
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    var mousePos: CGPoint = NSEvent.mouseLocation
    
    func addMouseEventMonitor() {
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged, .otherMouseDragged]) { event in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = ScreenManager.shared.GetScreen().frame.height - NSEvent.mouseLocation.y
        }
    }
    
    func fire() {
        if !SettingsManager.shared.snappingEnabled.value {
            return
        }
        
        for item in (ResizeType.allCases.filter {$0.forSnapping()}) {
            guard let rect = item.rect(WindowManager.shared.currentApplication) else {
                continue
            }
            
            if self.checkBoundingBox(self.mousePos, rect) {
                item.execute()
                return
            }
        }
        
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
}

import Foundation
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    var mousePos: CGPoint = NSEvent.mouseLocation
    
    let snapTime: Int64 = 1100 // need to add this to user settings (in miliseconds)
    var dragStartDate: Date? = nil
    var displayRect: Bool = false
    
    func addMouseEventMonitor() {
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged, .otherMouseDragged]) { event in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = ScreenManager.shared.GetScreen().frame.height - NSEvent.mouseLocation.y
            
            if self.dragStartDate == nil {
                self.dragStartDate = Date()
                self.displayRect = true
                Timer.scheduledTimer(timeInterval: Double(self.snapTime) / 1000.0, target: self, selector: #selector(self.rect), userInfo: nil, repeats: false)
            }
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { event in
            self.restart()
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) { event in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            if self.dragStartDate == nil {
                return
            }
            
            if Int64((Date().timeIntervalSince(self.dragStartDate ?? Date()) * 1000.0).rounded()) >= self.snapTime{                
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
            
            self.restart()
        }
    }
    
    @objc func rect() {
        if displayRect {
            return
        }
        
        
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
    
    private func restart() {
        self.dragStartDate = nil
        self.displayRect = false
    }
}

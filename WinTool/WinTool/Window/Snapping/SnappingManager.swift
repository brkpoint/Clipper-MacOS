import Foundation
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    var mousePos: CGPoint = NSEvent.mouseLocation
    
    let snapTime: Int64 = 1100 // need to add this to user settings (in miliseconds)
    var dragStartDate: Date? = nil
    
    var overlayWindow: NSWindow
    var timer: Timer? = nil
    
    init() {
        overlayWindow = SnapOverlay();
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged, .otherMouseDragged]) { event in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            if WindowManager.shared.currentApplication.isFullscreen ||
                !WindowManager.shared.currentApplication.isResizable {
                return
            }
            
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = ScreenManager.shared.GetScreen().frame.height - NSEvent.mouseLocation.y
            
            self.dragStartDate = Date()
            self.timer = Timer.scheduledTimer(timeInterval: Double(self.snapTime) / 1000.0, target: self, selector: #selector(self.showRect), userInfo: nil, repeats: false)
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) { event in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            if self.dragStartDate == nil {
                return
            }
        
            if !Process.isAllowedToUseAccessibilty() {
                return
            }
            
            if WindowManager.shared.currentApplication.isFullscreen ||
                !WindowManager.shared.currentApplication.isResizable {
                return
            }
            
            if Int64((Date().timeIntervalSince(self.dragStartDate ?? Date()) * 1000.0).rounded()) < self.snapTime {
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
            
            self.restart()
        }
    }
    
    @objc func showRect() {
        if !Process.isAllowedToUseAccessibilty() {
            return
        }
        
        if WindowManager.shared.currentApplication.isFullscreen ||
            !WindowManager.shared.currentApplication.isResizable {
            return
        }
        
        self.overlayWindow.orderFront(nil)
    }
    
    func hideRect() {
        if !Process.isAllowedToUseAccessibilty() {
            return
        }
        
        if WindowManager.shared.currentApplication.isFullscreen ||
            !WindowManager.shared.currentApplication.isResizable {
            return
        }
        
        self.overlayWindow.orderOut(nil)
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
    
    private func restart() {
        self.dragStartDate = nil
        hideRect()
    }
}

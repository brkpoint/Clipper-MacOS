import Foundation
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    var mousePos: CGPoint = NSEvent.mouseLocation
    var prevMousePos: CGPoint = NSEvent.mouseLocation
    
    let snapTime: Double = 1100.0 // need to add this to user settings (in miliseconds)
    
    var couldSnap = false
    var mouseDown = false
    var mouseMoving = false
    
    var overlayWindow: NSWindow
    var timer: Timer?
    var snapTimer: Timer? = nil
    
    init() {
        overlayWindow = SnapOverlay();
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            self.prevMousePos = self.mousePos
            
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = ScreenManager.shared.GetScreen().frame.height - NSEvent.mouseLocation.y
            
            if self.mousePos.x != self.prevMousePos.x || self.mousePos.y != self.prevMousePos.y {
                self.mouseMoving = true
                
                self.couldSnap = false
                self.snapTimer?.invalidate()
                self.snapTimer = nil
                return
            }
            
            self.mouseMoving = false

            if self.snapTimer == nil {
                self.snapTimer = Timer.scheduledTimer(timeInterval: self.snapTime, target: (Any).self, selector: #selector(self.snap), userInfo: nil, repeats: false)
            }
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
            self.mouseDown = true
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) { event in
            if !SettingsManager.shared.snappingEnabled.value {
                return
            }
            
            if !self.couldSnap {
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
    
    @objc func snap() {
        self.couldSnap = true
        showRect()
    }
    
    func showRect() {
        if !Process.isAllowedToUseAccessibilty() {
            return
        }
        
        self.overlayWindow.orderFront(nil)
    }
    
    func hideRect() {
        if !Process.isAllowedToUseAccessibilty() {
            return
        }
        
        self.overlayWindow.orderOut(nil)
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
    
    private func restart() {
        self.mouseDown = false
        self.snapTimer = nil
        self.couldSnap = false
        hideRect()
    }
}

import Foundation
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    var mousePos: CGPoint = NSEvent.mouseLocation
    var prevMousePos: CGPoint = NSEvent.mouseLocation
    
    let snapTime: Double = 0.45 // need to add this to user settings (in miliseconds)
    var snapTimeCounter: Double = 0
    
    var couldSnap = false
    var mouseDown = false
    
    var overlayWindow: NSWindow
    var timer: Timer?
    
    var resizeItem: ResizeType? = nil
    
    init() {
        overlayWindow = SnapOverlay();
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in // fix the timing (for later)
            if !SettingsManager.shared.snappingEnabled.value { return }
            
            self.prevMousePos = self.mousePos
            
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = ScreenManager.shared.GetScreen().frame.height - NSEvent.mouseLocation.y
            
            if self.mousePos.x != self.prevMousePos.x || self.mousePos.y != self.prevMousePos.y {
                self.snapTimeCounter = 0
                self.restart()
                return
            }
            
            self.snapTimeCounter += 0.25
            if self.mouseDown && self.snapTimeCounter > self.snapTime &&
                WindowManager.shared.currentApplication.isWindow &&
                !WindowManager.shared.currentApplication.isFullscreen {
                self.couldSnap = true
                for item in (SnapArea.allCases) {
                    guard let rect = item.rect(WindowManager.shared.currentApplication) else { continue }
                    
                    if self.checkBoundingBox(self.mousePos, rect) {
                        self.showRect(item.overlayRect(WindowManager.shared.currentApplication))
                        self.resizeItem = item.resizeType;
                        return
                    }
                }
            }
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
            self.mouseDown = true
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) { event in
            self.mouseDown = false
            
            if !SettingsManager.shared.snappingEnabled.value { return }
            
            if !self.couldSnap && !self.mouseDown { return }
            
            if self.resizeItem == nil { return }
            
            self.resizeItem?.execute();
            
            self.restart()
        }
    }
    
    func showRect(_ rect: CGRect?) {
        if !Process.isAllowedToUseAccessibilty() { return }
        if rect == nil { return }
        
        self.overlayWindow.orderFront(nil)
        self.overlayWindow.setFrame(rect as! CGRect, display: false)
    }
    
    func hideRect() {
        if !Process.isAllowedToUseAccessibilty() { return }
        
        self.overlayWindow.orderOut(nil)
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
    
    private func restart() {
        self.couldSnap = false
        self.resizeItem = nil
        self.hideRect()
    }
}

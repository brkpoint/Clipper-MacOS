import Foundation
import Cocoa

class SnappingManager {
    static var shared: SnappingManager = SnappingManager()
    
    var mousePos: CGPoint = NSEvent.mouseLocation
    var prevMousePos: CGPoint = NSEvent.mouseLocation
    
    var snapTimeCounter: Double = 0
    
    var couldSnap = false
    var mouseDown = false
    
    var overlayWindow: SnapOverlay = SnapOverlay();
    var timer: Timer?
    
    var resize: ResizeType? = nil
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
            if !SettingsData.shared.snappingEnabled.value { return }
            
            if WindowManager.shared.currentApplication.isFullscreen { return }
            
            self.prevMousePos = self.mousePos
            
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = (NSScreen.main ?? NSScreen()).frame.height - NSEvent.mouseLocation.y
            
            if self.mousePos.x != self.prevMousePos.x || self.mousePos.y != self.prevMousePos.y {
                self.restart()
                return
            }
            
            self.snapTimeCounter += 0.25
            
            if !self.mouseDown || self.snapTimeCounter < SettingsData.shared.timeToSnap.value || !WindowManager.shared.currentApplication.isWindow || WindowManager.shared.currentApplication.isFullscreen { return }
            
            self.couldSnap = true
            
            for item in SnapArea.allCases {
                guard let rect = item.rect() else { continue }
                if !self.checkBoundingBox(self.mousePos, rect) { continue }
                
                self.resize = item.resizeType;
                self.showRect(item.overlayRect())
            }
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
            self.mouseDown = true
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) { event in
            self.mouseDown = false
            
            if !SettingsData.shared.snappingEnabled.value { return }
            
            if !self.couldSnap && !self.mouseDown { return }
            
            guard let resizeType = self.resize else { return }
            
            WindowManager.shared.Align(resizeType);
            
            self.restart()
        }
    }
    
    func showRect(_ rect: CGRect?) {
        if !Process.isAllowedToUseAccessibilty() { return }
        guard let rect = rect else { return }
        
        self.overlayWindow.orderFront(nil)
        self.overlayWindow.setFrame(rect, display: false)
    }
    
    func hideRect() {
        if !Process.isAllowedToUseAccessibilty() { return }
        
        self.overlayWindow.orderOut(nil)
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
    
    private func restart() {
        self.snapTimeCounter = 0
        self.couldSnap = false
        self.resize = nil
        self.hideRect()
    }
}

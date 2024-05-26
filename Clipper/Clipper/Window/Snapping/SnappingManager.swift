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
    
    var area: SnapArea? = nil
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
            if !SettingsData.shared.snappingEnabled.value { return }
            
            if WindowManager.shared.application.isFullscreen || !WindowManager.shared.application.isWindow || !WindowManager.shared.application.isResizable { return }
            
            self.prevMousePos = self.mousePos
            self.mousePos.x = NSEvent.mouseLocation.x
            self.mousePos.y = (NSScreen.main ?? NSScreen()).frame.height - NSEvent.mouseLocation.y
            
            if self.mousePos.x != self.prevMousePos.x || self.mousePos.y != self.prevMousePos.y {
                self.reset()
                return
            }
            
            self.snapTimeCounter += 0.25
            
            if !self.mouseDown || self.snapTimeCounter < SettingsData.shared.timeToSnap.value || self.couldSnap { return }
            
            self.couldSnap = true
            
            for item in SnapArea.allCases {
                if !self.checkBoundingBox(self.mousePos, item.rect()) { continue }
                
                self.area = item;
                self.showRect()
            }
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
            self.mouseDown = true
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) { event in
            if !SettingsData.shared.snappingEnabled.value { return }
            
            if !self.couldSnap { return }
            
            guard self.area != nil else { return }
            
            WindowManager.shared.Align(self.area!.resizeType);
            
            self.mouseDown = false
            self.reset()
        }
    }
    
    func showRect() {
        if !Process.isAllowedToUseAccessibilty() { return }
        
        self.overlayWindow.orderFront(nil)
        self.overlayWindow.setFrame(area!.overlayRect(), display: false)
    }
    
    func hideRect() {
        if !Process.isAllowedToUseAccessibilty() { return }
        
        self.overlayWindow.orderOut(nil)
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.origin.x && position.y > box.origin.y && position.x < box.width + box.origin.x && position.y < box.height + box.origin.y
    }
    
    private func reset() {
        self.snapTimeCounter = 0
        self.couldSnap = false
        self.area = nil
        self.hideRect()
    }
}

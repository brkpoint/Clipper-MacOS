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
            
            // first method
//            let firstX: Bool = (ScreenManager.shared.GetScreen().frame.width / 2) > NSEvent.mouseLocation.x // is mouse in the first x square
//            let firstY: Bool = (ScreenManager.shared.GetScreen().frame.height / 2) < NSEvent.mouseLocation.y // is mouse in the first y square
            
            // second method
//            var isInside: Bool = self.checkBoundingBox(NSEvent.mouseLocation, CGRect(x: 0, y: 0, width: 200, height: 200))
        }
    }
    
    private func checkBoundingBox(_ position: CGPoint, _ box: CGRect) -> Bool {
        return position.x > box.minX && position.y > box.minY && position.x < box.maxX && position.y < box.maxY
    }
}

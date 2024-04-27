import Foundation
import SwiftUI

class WindowElement {
    let name: String
    let ID: String
    let icon: NSImage

    fileprivate var element: AXUIElement = AXUIElementCreateSystemWide()
    private var mainApp: AXUIElement = AXUIElementCreateSystemWide()

    convenience init(_ name: String, _ ID: String, _ pid: pid_t?) {
        self.init(name, ID, pid, NSImage())
    }

    init(_ name: String, _ ID: String, _ pid: pid_t?, _ icon: NSImage) {
        self.name = name
        self.ID = ID
        self.icon = icon
        
        if pid == nil { return}
        mainApp = AXUIElementCreateApplication(pid!)
        
        if !Process.isAllowedToUseAccessibilty() { return }
        if let val = mainApp.getValue(.focusedWindow) {
            element = val as! AXUIElement
        }
    }
    
    private func getAXValue(_ attribute: NSAccessibility.Attribute) -> AXUIElement? {
        guard let value = element.getValue(attribute), CFGetTypeID(value) == AXUIElementGetTypeID() else { return nil }
        return value as! AXUIElement
    }
    
    private var focusedWindow: AXUIElement {
        mainApp.getValue(.focusedWindow) as! AXUIElement
    }
    
    private var role: NSAccessibility.Role? {
        guard let value = element.getValue(.role) as? String else { return nil }
        return NSAccessibility.Role(rawValue: value)
    }

    private var position: CGPoint? {
        get {
            element.getWrappedValue(.position)
        }
        set {
            guard let newValue = newValue else { return }
            element.setValue(.position, newValue)
        }
    }

    private var size: CGSize? {
        get {
            element.getWrappedValue(.size)
        }
        set {
            guard let newValue = newValue else { return }
            element.setValue(.size, newValue)
        }
    }

    var isResizable: Bool {
        element.isSettable(.size)
    }
    
    var isFullscreen: Bool {
        guard let value = getAXValue(.fullScreenButton)?.getValue(.subrole) as? String else { return false }
        return NSAccessibility.Subrole(rawValue: value) == .zoomButton
    }
    
    var isHidden: Bool {
        guard let value = element.getValue(.hidden) as? Bool else { return false }
        return value
    }
    
    var isWindow: Bool {
        guard let role = role else { return false }
        return role == .window
    }

    var frame: CGRect {
        guard let position = position, let size = size else { return .null }
        return .init(origin: position, size: size)
    }

    func setFrame(_ nFrame: CGRect) {
        if !isResizable || isFullscreen {
            NSSound.beep()
            return
        }

        position = nFrame.origin
        size = nFrame.size

        print("INFO: Resizing window: \(element.getValue(.title) as? String ?? "N/A"), to rect: \(nFrame)")
    }
}

import Foundation
import SwiftUI

class WindowElement {
    let name: String
    let ID: String
    let icon: NSImage

    private var mainApp: AXUIElement = AXUIElementCreateSystemWide()

    convenience init(_ name: String, _ ID: String, _ pid: pid_t?) {
        self.init(name, ID, pid, NSImage())
    }

    init(_ name: String, _ ID: String, _ pid: pid_t?, _ icon: NSImage) {
        self.name = name
        self.ID = ID
        self.icon = icon
        
        if pid == nil { return }
        mainApp = AXUIElementCreateApplication(pid!)
    }
    
    private func getAXValue(_ attribute: NSAccessibility.Attribute) -> AXUIElement? {
        guard let value = focusedWindow.getValue(attribute), CFGetTypeID(value) == AXUIElementGetTypeID() else { return nil }
        return value as! AXUIElement
    }
    
    private var focusedWindow: AXUIElement {
        if let window = mainApp.getValue(.focusedWindow) {
            return window as! AXUIElement
        }
        if let window = windows?.first {
            return window
        }
        
        return AXUIElementCreateSystemWide()
    }
    
    private var role: NSAccessibility.Role? {
        guard let value = focusedWindow.getValue(.role) as? String else { return nil }
        return NSAccessibility.Role(rawValue: value)
    }

    private var position: CGPoint? {
        get {
            focusedWindow.getWrappedValue(.position)
        }
        set {
            guard let newValue = newValue else { return }
            focusedWindow.setValue(.position, newValue)
        }
    }

    private var size: CGSize? {
        get {
            focusedWindow.getWrappedValue(.size)
        }
        set {
            guard let newValue = newValue else { return }
            focusedWindow.setValue(.size, newValue)
        }
    }
    
    var windowName: String {
        guard let value = focusedWindow.getValue(.title) else { return "N/A" }
        return value as! String
    }
    
    var windows: [AXUIElement]? {
        guard let value = mainApp.getValue(.windows), let arr = value as? [AXUIElement] else { return nil }
        return arr
    }

    var isResizable: Bool {
        focusedWindow.isSettable(.size)
    }
    
    var isFullscreen: Bool {
        guard let value = getAXValue(.fullScreenButton)?.getValue(.subrole) as? String else { return false }
        return NSAccessibility.Subrole(rawValue: value) == .zoomButton
    }
    
    var isHidden: Bool {
        guard let value = focusedWindow.getValue(.hidden) as? Bool else { return false }
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

        print("INFO: Resizing window: \(focusedWindow.getValue(.title) as? String ?? "N/A"), to rect: \(nFrame)")
    }
}

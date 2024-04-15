import Foundation
import SwiftUI

class WindowElement {
    let name: String
    let ID: String
    let icon: NSImage

    fileprivate var axUIElement: AXUIElement?
    private let mainApp: AXUIElement?

    convenience init(_ name: String, _ ID: String, _ pid: pid_t) {
        self.init(name, ID, pid, NSImage())
    }

    init(_ name: String, _ ID: String, _ pid: pid_t, _ icon: NSImage) {
        self.name = name
        self.ID = ID
        self.icon = icon

        if !Process.isAllowedToUseAccessibilty() {
            mainApp = nil
        } else {
            mainApp = AXUIElementCreateApplication(pid)
        }
        
        axUIElement = nil
    }
    
    private func getAXValue(_ attribute: NSAccessibility.Attribute) -> AXUIElement? {
        guard let value = axUIElement?.getValue(attribute), CFGetTypeID(value) == AXUIElementGetTypeID() else { return nil }
        return value as! AXUIElement
    }

    private var position: CGPoint? {
        get {
            axUIElement?.getWrappedValue(.position)
        }
        set {
            guard let newValue = newValue else { return }
            axUIElement?.setValue(.position, newValue)
        }
    }

    private var size: CGSize? {
        get {
            axUIElement?.getWrappedValue(.size)
        }
        set {
            guard let newValue = newValue else { return }
            axUIElement?.setValue(.size, newValue)
        }
    }

    var isResizable: Bool {
        get {
            axUIElement?.isSettable(.size) ?? true
        }
    }
    
    var isFullscreen: Bool {
        get {
            guard let subrole = getAXValue(.fullScreenButton)?.getValue(.subrole) as? String else { return false }
            return NSAccessibility.Subrole(rawValue: subrole) == .zoomButton
        }
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

        print("INFO: Resizing window: \(axUIElement?.getValue(.title) as? String ?? "N/A"), to rect: \(nFrame)")
    }

    func getWindow() {
        if let window = mainApp?.getValue(.focusedWindow) {
            axUIElement = window as! AXUIElement
        }
    }
    
}

import Foundation
import Cocoa
import SwiftUI

class SnapOverlay: NSWindow {
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: .titled, backing: .buffered, defer: false)
        title = Main.shared.appName + "Overlay"
        level = .modalPanel
        alphaValue = 0
        
        isOpaque = false
        styleMask.insert(.fullSizeContentView)
        
        isReleasedWhenClosed = false
        ignoresMouseEvents = true
        hasShadow = false
        collectionBehavior.insert(.transient)
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        standardWindowButton(.toolbarButton)?.isHidden = true
        
        var view = NSBox()
        view.boxType = .custom
        view.fillColor = NSColor(SettingsManager.shared.overlayBackgroundColor.value)
        view.borderColor = NSColor(SettingsManager.shared.overlayBorderColor.value)
        view.cornerRadius = SettingsManager.shared.overlayCornerRadius.value
        view.wantsLayer = true
        contentView = view
    }
    
    override func orderFront(_ sender: Any?) {
        super.orderFront(sender)
        animator().alphaValue = SettingsManager.shared.overlayAlpha.value / 100
    }
    
    override func orderOut(_ sender: Any?) {
        NSAnimationContext.runAnimationGroup { change in
            animator().alphaValue = 0.0
        } completionHandler: {
            super.orderOut(sender)
        }
    }
    
    public func updateSettings() {
        var view = NSBox()
        view.boxType = .custom
        view.fillColor = NSColor(SettingsManager.shared.overlayBackgroundColor.value)
        view.borderColor = NSColor(SettingsManager.shared.overlayBorderColor.value)
        view.cornerRadius = SettingsManager.shared.overlayCornerRadius.value
        view.wantsLayer = true
        contentView = view
    }
}

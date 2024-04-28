import Foundation
import Cocoa
import SwiftUI

class SnapOverlay: NSWindow {
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: .titled, backing: .buffered, defer: false)
        title = Main.shared.appName + "Overlay"
        level = .modalPanel
        
        isOpaque = false
        styleMask.insert(.fullSizeContentView)
        alphaValue = 0
        
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
        
        let view = NSBox()
        view.boxType = .custom
        view.fillColor = .controlBackgroundColor
        view.borderColor = .controlAccentColor
        view.cornerRadius = 10
        view.wantsLayer = true
        contentView = view
    }
    
    override func orderFront(_ sender: Any?) {
        super.orderFront(sender)
        animator().alphaValue = 0.45
    }
    
    override func orderOut(_ sender: Any?) {
        NSAnimationContext.runAnimationGroup { change in
            animator().alphaValue = 0.0
        } completionHandler: {
            super.orderOut(sender)
        }
    }
    
    func updateSettings() {
//        let view = NSBox()
//        view.boxType = .custom
//        view.fillColor = .controlBackgroundColor
//        view.borderColor = .controlAccentColor
//        view.cornerRadius =
//        view.wantsLayer = true
//        contentView = view
    }
}

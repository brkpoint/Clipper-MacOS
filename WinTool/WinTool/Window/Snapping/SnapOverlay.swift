import Foundation
import Cocoa
import SwiftUI

class SnapOverlay: NSWindow {
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: .titled, backing: .buffered, defer: false)
        title = Main.shared.appName + "Overlay"
        level = .modalPanel
        
        isOpaque = false
        styleMask.insert(.fullSizeContentView)
        alphaValue = 0.45
        
        isReleasedWhenClosed = false
        
        hasShadow = false

        ignoresMouseEvents = true
        
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
}

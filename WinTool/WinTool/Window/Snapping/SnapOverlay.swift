import Foundation
import Cocoa
import SwiftUI

class SnapOverlay: NSWindow {
    init() {
        super.init(contentRect: NSRect(x: 5, y: 5, width: 500, height: 500), styleMask: .titled, backing: .buffered, defer: false)
        title = Main.shared.appName + "Overlay"
        isOpaque = false
        level = .modalPanel
        hasShadow = false
        isReleasedWhenClosed = false
        alphaValue = 0.45
        styleMask.insert(.fullSizeContentView)
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        ignoresMouseEvents = true
        collectionBehavior.insert(.transient)
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        standardWindowButton(.toolbarButton)?.isHidden = true
        
        let boxView = NSBox()
        boxView.boxType = .custom
        boxView.fillColor = .controlBackgroundColor
        boxView.borderColor = .controlAccentColor
        boxView.cornerRadius = 10
        boxView.wantsLayer = true
        contentView = boxView
    }
}

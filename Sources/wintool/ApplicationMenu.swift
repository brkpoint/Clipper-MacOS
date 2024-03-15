import Foundation
import SwiftUI

@available(macOS 14.0, *)
class ApplicationMenu: NSObject {
    private let windowManager = WindowManager.shared

    let menu = NSMenu()
    
    func createMenu() -> NSMenu {
        let viewMain = Main.shared.contentView
        let topView = NSHostingController(rootView: viewMain)
        topView.view.frame.size = CGSize(width: 225, height: 150)
     
        let customMenuItem = NSMenuItem()
        customMenuItem.view = topView.view

        menu.addItem(customMenuItem)
        menu.addItem(NSMenuItem.separator())

        let quitMenuItem = NSMenuItem(title: "Quit",
                                                  action: #selector(quit),
                                                  keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        return menu
    }
    
    @objc func about(sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel()
    }

    @objc func quit(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}

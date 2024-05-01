import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = AppMenu()
    
    let windowManager = WindowManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        initialize()
        AppDelegate.instance = self
        
        registerFrontAppChangeNote()
        if let button = statusBarItem.button {
            let image = NSImage(named: "BarIcon")
            image?.isTemplate = true
            button.image = image
        }
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
    }

    private func initialize() {
        SnappingManager()
        Process.askForAccessibilityIfNeeded()

        if Process.isSandboxingEnabled() {
            print("ERR: Sandboxing is enabled")
        } else {
            print("INFO: Sandboxing is disabled")
        }

        if let application = NSWorkspace.shared.frontmostApplication {
            setupWindow(application)
        }
        
        guard let url = NSWorkspace.shared.desktopImageURL(for: NSScreen.main!) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            guard let nsimg = NSImage(data: data) else { return }
            
            Main.shared.wallpaper = Image(nsImage: nsimg)
        } catch {
            print("Wallpaper load error")
        }
    }

    private func setupWindow(_ application: NSRunningApplication) {
        if application.bundleIdentifier == Main.shared.bundleIdentifier { return }
        
        if !Process.isAllowedToUseAccessibilty() { return }
        
        windowManager.SetApp(WindowElement(application.localizedName!, application.bundleIdentifier!, application.processIdentifier, application.icon!))
        ScreenManager.shared.UpdateScreen()
    }

    private func registerFrontAppChangeNote() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveFrontAppChangeNote(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }

    @objc func receiveFrontAppChangeNote(_ notification: Notification) {
        if let application = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication {
            setupWindow(application)
        }
    }
}

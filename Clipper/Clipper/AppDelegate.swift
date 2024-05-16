import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = AppMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        initialize()
        
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
        
        if let url = NSWorkspace.shared.desktopImageURL(for: NSScreen.main!) {
            do {
                let data = try Data(contentsOf: url)
                guard let nsimg = NSImage(data: data) else { return }
                
                Main.shared.wallpaper = Image(nsImage: nsimg)
            } catch {
                print("ERR: Wallpaper load error")
            }
        }
        
        print("INFO: registering app change event")
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.appChanged(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }

    private func setupWindow(_ application: NSRunningApplication) {
        if application.bundleIdentifier == Bundle.main.bundleIdentifier { return }
        
        if !Process.isAllowedToUseAccessibilty() { return }
        
        WindowManager.shared.SetApp(WindowElement(application.localizedName!, application.bundleIdentifier!, application.processIdentifier, application.icon!))
    }

    @objc func appChanged(_ notification: Notification) {
        if let application = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication { setupWindow(application) }
    }
}

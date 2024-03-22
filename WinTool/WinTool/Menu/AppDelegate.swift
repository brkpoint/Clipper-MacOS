import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = AppMenu()
    
    let windowManager = WindowManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        initialize()

        AppDelegate.instance = self
        registerFrontAppChangeNote()
        if let button = statusBarItem.button {
           let image = NSImage(named: "AppIcon")
           image?.isTemplate = true
           button.image = image
        }
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
    }

    private func initialize() {
        AXUIElement.askForAccessibilityIfNeeded() // to fix
        Main.shared.shortcutsEnabled = UserDefaults.standard.bool(forKey: Main.shared.shortcutUserDefaultsKey)

        if AXUIElement.isSandboxingEnabled() {
            print("ERR: Sandboxing is enabled")
        } else {
            print("INFO: Sandboxing is disabled")
        }

        if let application = NSWorkspace.shared.frontmostApplication {
            setupWindow(application)
        }

//        if SMAppService.mainApp.status != .enabled {
//            do {
//                try SMAppService.mainApp.register()
//                print("INFO: Successfully added to launch on startup")
//            } catch {
//                print("ERR: Failed to add to launch on startup")
//            }
//        } else {
//            print("INFO: App is added to launch on startup")
//        }
    }

    private func setupWindow(_ application: NSRunningApplication) {
        windowManager.SetApp(WindowElement(application.localizedName!, application.bundleIdentifier!, application.processIdentifier, application.icon!))
        windowManager.GetCurrentApp().getWindow()
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

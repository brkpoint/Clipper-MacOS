import SwiftUI
import Cocoa
import ServiceManagement
import HotKey

@main
struct Main: App {
    private let windowManager = WindowManager.shared

    static var shared: Main = Main()
    let bundleIdentifier = "com.shibaofficial.wintool"
    var hotKeysDictionary: [ResizeType : HotKey] = [:]
    var contentView = ContentView()
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            contentView
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    let menu = ApplicationMenu()
    let windowManager = WindowManager.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        initialize()

        AppDelegate.instance = self
        registerFrontAppChangeNote()
        if let button = statusBarItem.button {
           let image = NSImage(contentsOfFile: "./Assets/AppIcons/Icon.png")
           image?.isTemplate = true
           button.image = image
        }
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
    }

    private func initialize() {
        AXUIElement.askForAccessibilityIfNeeded()

        if AXUIElement.isSandboxingEnabled() {
            print("ERR: Sandboxing is enabled")
        } else {
            print("INFO: Sandboxing is disabled")
        }

        if let application = NSWorkspace.shared.frontmostApplication {
            setupWindow(application)
        }

        if SMAppService.mainApp.status != .enabled {
            do {
                try SMAppService.mainApp.register()
                print("INFO: Successfully added to launch on startup")
            } catch {
                print("ERR: Failed to add to launch on startup")
            }
        } else {
            print("INFO: App is added to launch on startup")
        }

        for item in ResizeType.allCases {
            let hotKey = HotKey(key: item.key, modifiers: item.modifiers)
            hotKey.keyDownHandler = {
                WindowManager.shared.Align(item)
            }
            Main.shared.hotKeysDictionary[item] = hotKey
        }

        print("INFO: Added global shortcuts")
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

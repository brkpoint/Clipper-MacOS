import SwiftUI
import Cocoa

@main
struct Main: App {
    static var shared: Main = Main()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var contentView: ContentView = ContentView()
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

    private func registerFrontAppChangeNote() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveFrontAppChangeNote(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }

    @objc func receiveFrontAppChangeNote(_ notification: Notification) {
        if let application = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication {
            // appId - application.bundleIdentifier
            // appName - application.localizedName

            if let window = getFrontmostWindow(for: application.processIdentifier) {
                windowManager.SetApp(WindowElement(application.localizedName!, "", application.bundleIdentifier!, application.icon!, window))
                window.setFrame(NSRect(x: 0, y: 0, width: 1200, height: 800), display: true)
            }
            
            func getFrontmostWindow(for processIdentifier: pid_t) -> NSWindow? {
                let appElement = AXUIElementCreateApplication(processIdentifier)
                
                var result: CFTypeRef?
                let error = AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &result)
                
                if error == .success, let windowRef = result {
                    let windowElement = windowRef as! AXUIElement
                    
                    var title: CFTypeRef?
                    AXUIElementCopyAttributeValue(windowElement, kAXTitleAttribute as CFString, &title)
                    
                    if let titleValue = title as? String {
                        let windowPtr = UnsafeMutableRawPointer(Unmanaged.passUnretained(windowElement).toOpaque())
                        return NSWindow(windowRef: windowPtr)
                    } else {
                        print("Failed to retrieve window title.")
                    }
                }
                
                return nil
            }
        }
    }
}

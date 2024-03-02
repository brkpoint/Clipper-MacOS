import SwiftUI
import Cocoa

func getFrontWindow() -> [String:Any]? {
    let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
    let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
    let infoList = windowsListInfo as! [[String:Any]]
    let visibleWindows = infoList.filter{ $0["kCGWindowLayer"] as! Int == 0 }
    let frontMostAppID = Int(NSWorkspace.shared.frontmostApplication!.processIdentifier)
    for window in visibleWindows {
        if frontMostAppID == window["kCGWindowOwnerPID"] as! Int {
            return window
        }
    }
    return nil
}

@main
struct WinTool: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        if let button = statusBarItem.button {
           let image = NSImage(contentsOfFile: "./Assets/AppIcons/Icon.png")
           image?.isTemplate = true
           button.image = image
        }
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()

        print(getFrontWindow())
    }
}

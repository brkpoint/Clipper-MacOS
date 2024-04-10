import Cocoa
import SwiftUI
import ServiceManagement
import KeyboardShortcuts

@main
struct Main: App {
    static var shared: Main = Main()
    let bundleIdentifier = "com.shibaofficial.WinTool"
    let userDefaultsKey = "setting."
    var contentView = MenuView()
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState: AppState = AppState()
    @ObservedObject var shortcuts: Shortcuts = Shortcuts()
    var body: some Scene {
        Settings {
            SettingsView()
        }
        WindowGroup {
            OverlayView()
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    init() {
        for item in ResizeType.allCases {
            let shortcut = KeyboardShortcuts.Name.init(item.rawValue, default: .init(item.key, modifiers: [item.modifiers]))
            Main.shared.shortcuts.list.append(Shortcut(shortcut, item.rawValue))
            KeyboardShortcuts.onKeyDown(for: shortcut) {
                if !SettingsManager.shared.shortcutsEnabled.value {
                    return
                }
                
                item.execute()
            }
        }

        print("INFO: Added global shortcuts")
    }
}

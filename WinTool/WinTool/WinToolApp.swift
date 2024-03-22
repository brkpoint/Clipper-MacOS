import Cocoa
import SwiftUI
import ServiceManagement
import KeyboardShortcuts

@main
struct Main: App {
    private let windowManager = WindowManager.shared

    static var shared: Main = Main()
    let bundleIdentifier = "com.shibaofficial.WinTool"
    let shortcutUserDefaultsKey = "shortcutsEnabled"
    var contentView = MenuView()
    var shortcutsEnabled = true
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState: AppState = AppState()
    @ObservedObject var shortcuts: Shortcuts = Shortcuts()
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    init() {
        for item in ResizeType.allCases {
            let shortcut = KeyboardShortcuts.Name.init(item.rawValue, default: .init(item.key, modifiers: [item.modifiers]))
            Main.shared.shortcuts.list.append(Shortcut(name: shortcut, title: item.rawValue))
            KeyboardShortcuts.onKeyDown(for: shortcut) { [self] in
                if Main.shared.shortcutsEnabled {
                    WindowManager.shared.Align(item)
                }
            }
        }

        print("INFO: Added global shortcuts")
    }
}

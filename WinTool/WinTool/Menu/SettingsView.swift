import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, keybinds
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            KeybindsSettingsView()
                .tabItem {
                    Label("Keybinds", systemImage: "keyboard.badge.ellipsis")
                }
                .tag(Tabs.keybinds)
        }
        .frame(width: 400, height: 200)
    }
}

struct GeneralSettingsView: View {
    @State private var shortcutsEnabled = SettingsManager.shared.shortcutsEnabled.value
    @State private var snappingEnabled = SettingsManager.shared.snappingEnabled.value
    
    var body: some View {
        Form {
            VStack {
                Toggle("Shortcuts", isOn: $shortcutsEnabled)
                    .onChange(of: shortcutsEnabled) {
                        SettingsManager.shared.shortcutsEnabled.value = shortcutsEnabled
                    }
                Toggle("Snapping", isOn: $snappingEnabled)
                    .onChange(of: snappingEnabled) {
                        SettingsManager.shared.shortcutsEnabled.value = snappingEnabled
                    }
                LaunchAtLogin.Toggle("Toggle launch at login")
            }
        }
    }
}

struct KeybindsSettingsView: View {
    var body: some View {
        Form {
            ScrollView(.vertical) {
                Button("Reset All") {
                    for item in Main.shared.shortcuts.list {
                        KeyboardShortcuts.reset(item.name)
                    }
                }
                VStack {
                    ForEach(Main.shared.$shortcuts.list) { $shortcut in
                        HStack {
                            Text(shortcut.title)
                            KeyboardShortcuts.Recorder(for: shortcut.name)
                        }
                    }
                    .padding(2)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(5)
    }
}

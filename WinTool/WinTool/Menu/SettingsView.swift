import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, keybinds, appearance
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
                .padding(5)
            KeybindsSettingsView()
                .tabItem {
                    Label("Keybinds", systemImage: "keyboard.badge.ellipsis")
                }
                .tag(Tabs.keybinds)
                .padding(5)
            AppearanceSettingsView()
                .tabItem {
                    Label("Appearance", systemImage: "sparkles")
                }
                .tag(Tabs.appearance)
                .padding(5)
        }
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
        .frame(width: 450, height: 200)
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
        .frame(width: 450, height: 200)
        .padding(5)
    }
}

struct AppearanceSettingsView: View {
    @State private var overlayAlpha = SettingsManager.shared.overlayAlpha.value / 10
    @State private var overlayBorderColor = Color(SettingsManager.shared.overlayBorderColor.value)
    @State private var overlayBackgroundColor = Color(SettingsManager.shared.overlayBackgroundColor.value)
    
    var body: some View {
        Form {
            HStack {
                VStack {
                    Button("Reset All") {
                        SettingsManager.shared.overlayAlpha.reset()
                        SettingsManager.shared.overlayBorderColor.reset()
                        SettingsManager.shared.overlayBackgroundColor.reset()
                        
                        overlayAlpha = SettingsManager.shared.overlayAlpha.value / 10
                        overlayBorderColor = Color(SettingsManager.shared.overlayBorderColor.value)
                        overlayBackgroundColor = Color(SettingsManager.shared.overlayBackgroundColor.value)
                    }
                    Slider(value: $overlayAlpha, in: 0...10, step: 1, minimumValueLabel: Text("1"), maximumValueLabel: Text("100")) {
                        Label("Overlay Alpha", systemImage: "circle.lefthalf.filled")
                    }
                    .onChange(of: overlayAlpha) {
                        SettingsManager.shared.overlayAlpha.value = CGFloat(overlayAlpha * 10)
                    }
                    .padding(5)
                    ColorPicker(selection: $overlayBorderColor, supportsOpacity: false) {
                        Label("Overlay Border Color", systemImage: "square")
                    }
                    .onChange(of: overlayBorderColor) {
                        SettingsManager.shared.overlayBorderColor.value = overlayBorderColor.hex()
                    }
                    .padding(5)
                    ColorPicker(selection: $overlayBackgroundColor, supportsOpacity: false) {
                        Label("Overlay Background Color", systemImage: "square.fill")
                    }
                    .onChange(of: overlayBackgroundColor) {
                        SettingsManager.shared.overlayBackgroundColor.value = overlayBackgroundColor.hex()
                    }
                    .padding(5)
                }
                .padding(5)
                VStack {
                    Text("Preview:")
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(overlayBorderColor)
                        .fill(overlayBackgroundColor)
                        .frame(width: 180, height: 180)
                        .opacity(Double(overlayAlpha / 10))
                        .padding(5)
                }
            }
        }
        .frame(width: 500, height: 250)
        .padding(5)
    }
}

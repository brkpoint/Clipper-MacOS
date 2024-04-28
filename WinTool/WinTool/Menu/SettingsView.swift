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
    @State private var overlayCornerRadius = SettingsManager.shared.overlayCornerRadius.value
    @State private var overlayAlpha = SettingsManager.shared.overlayAlpha.value
    @State private var overlayBorderColor = Color(rgb: SettingsManager.shared.overlayBorderColor.value, a: 1)
    @State private var overlayBackgroundColor = Color(rgb: SettingsManager.shared.overlayBackgroundColor.value, a: 1)
    
    var body: some View {
        Form {
            HStack {
                VStack {
                    Slider(value: $overlayAlpha, in: 0...100, step: 5, minimumValueLabel: Text("1"), maximumValueLabel: Text("100")) {
                        Label("Overlay Alpha", systemImage: "circle.lefthalf.filled")
                    }
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .onChange(of: overlayAlpha) {
                        SettingsManager.shared.overlayAlpha.value = CGFloat(overlayAlpha)
                        SnappingManager().overlayWindow.update()
                    }
                    .padding(5)
                    Slider(value: $overlayCornerRadius, in: 1...18, step: 1, minimumValueLabel: Text("1"), maximumValueLabel: Text("18")) {
                        Label("Overlay Corner Radius", systemImage: "scribble")
                    }
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .onChange(of: overlayCornerRadius) {
                        SettingsManager.shared.overlayCornerRadius.value = CGFloat(overlayCornerRadius)
                        SnappingManager().overlayWindow.update()
                    }
                    .padding(5)
                    ColorPicker(selection: $overlayBorderColor, supportsOpacity: false) {
                        Label("Overlay Border Color", systemImage: "square")
                    }
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .onChange(of: overlayBorderColor) {
                        SettingsManager.shared.overlayBorderColor.value = overlayBorderColor.hex()
                        SnappingManager().overlayWindow.update()
                    }
                    .padding(5)
                    ColorPicker(selection: $overlayBackgroundColor, supportsOpacity: false) {
                        Label("Overlay Background Color", systemImage: "square.fill")
                    }
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .onChange(of: overlayBackgroundColor) {
                        SettingsManager.shared.overlayBackgroundColor.value = overlayBackgroundColor.hex()
                        SnappingManager().overlayWindow.update()
                    }
                    .padding(5)
                }
                .padding(5)
                VStack {
                    Text("Preview:")
                    RoundedRectangle(cornerRadius: overlayCornerRadius)
                        .stroke(overlayBorderColor, lineWidth: 5)
                        .fill(overlayBackgroundColor)
                        .frame(width: 180, height: 180)
                        .opacity(Double(overlayAlpha / 100))
                        .padding(5)
                }
            }
        }
        .frame(width: 500, height: 250)
        .padding(5)
    }
}

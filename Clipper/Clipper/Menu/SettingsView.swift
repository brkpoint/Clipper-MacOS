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
    @State private var shortcutsEnabled = SettingsData.shared.shortcutsEnabled.value
    @State private var snappingEnabled = SettingsData.shared.snappingEnabled.value
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Toggle("Shortcuts", isOn: $shortcutsEnabled)
                .onChange(of: shortcutsEnabled) {
                    SettingsData.shared.shortcutsEnabled.value = shortcutsEnabled
                }
                .alignmentGuide(.leading) { d in
                    d[.leading]
                }
                
                Toggle("Snapping", isOn: $snappingEnabled)
                .onChange(of: snappingEnabled) {
                    SettingsData.shared.shortcutsEnabled.value = snappingEnabled
                }
                .alignmentGuide(.leading) { d in
                    d[.leading]
                }
                
                LaunchAtLogin.Toggle("Toggle launch at login")
                .alignmentGuide(.leading) { d in
                    d[.leading]
                }
            }
        }
        .frame(width: 450, height: 200)
    }
}

struct KeybindsSettingsView: View {
    var body: some View {
        Form {
            Button("Reset All") {
                for item in Main.shared.shortcuts.list {
                    KeyboardShortcuts.reset(item.name)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(Main.shared.$shortcuts.list) { $shortcut in
                        HStack {
                            Text(shortcut.title)
                            KeyboardShortcuts.Recorder(for: shortcut.name)
                        }
                        .alignmentGuide(.leading) { d in
                            d[.leading]
                        }
                    }
                    .padding(2)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: 450, height: 200)
    }
}

struct AppearanceSettingsView: View {
    @State private var timeToSnap = SettingsData.shared.timeToSnap.value
    @State private var overlayAlpha = SettingsData.shared.overlayAlpha.value / 10
    @State private var overlayBorderColor = Color(SettingsData.shared.overlayBorderColor.value)
    @State private var overlayBackgroundColor = Color(SettingsData.shared.overlayBackgroundColor.value)
    
    var body: some View {
        Form {
            HStack {
                VStack {
                    Button("Reset All") {
                        SettingsData.shared.timeToSnap.reset()
                        SettingsData.shared.overlayAlpha.reset()
                        SettingsData.shared.overlayBorderColor.reset()
                        SettingsData.shared.overlayBackgroundColor.reset()
                        
                        timeToSnap = SettingsData.shared.timeToSnap.value
                        overlayAlpha = SettingsData.shared.overlayAlpha.value / 10
                        overlayBorderColor = Color(SettingsData.shared.overlayBorderColor.value)
                        overlayBackgroundColor = Color(SettingsData.shared.overlayBackgroundColor.value)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading) {
                        Slider(value: $timeToSnap, in: 0.3 ... 1.5, step: 0.1, minimumValueLabel: Text("0.3"), maximumValueLabel: Text("1.5")) {
                            Label("Time To Snap (In Seconds)", systemImage: "timer")
                        }
                        .onChange(of: timeToSnap) {
                            SettingsData.shared.timeToSnap.value = timeToSnap
                        }
                        .alignmentGuide(.leading) { d in
                            d[.leading]
                        }
                        .padding(5)
                        
                        Slider(value: $overlayAlpha, in: 0 ... 10, step: 0.5, minimumValueLabel: Text("1"), maximumValueLabel: Text("100")) {
                            Label("Overlay Alpha", systemImage: "circle.lefthalf.filled")
                        }
                        .onChange(of: overlayAlpha) {
                            SettingsData.shared.overlayAlpha.value = CGFloat(overlayAlpha * 10)
                        }
                        .alignmentGuide(.leading) { d in
                            d[.leading]
                        }
                        .padding(5)
                        
                        ColorPicker(selection: $overlayBorderColor, supportsOpacity: false) {
                            Label("Overlay Border Color", systemImage: "square")
                        }
                        .onChange(of: overlayBorderColor) {
                            SettingsData.shared.overlayBorderColor.value = overlayBorderColor.hex()
                            SnappingManager.shared.overlayWindow.colorUpdate()
                        }
                        .alignmentGuide(.leading) { d in
                            d[.leading]
                        }
                        .padding(5)
                        
                        ColorPicker(selection: $overlayBackgroundColor, supportsOpacity: false) {
                            Label("Overlay Background Color", systemImage: "square.fill")
                        }
                        .onChange(of: overlayBackgroundColor) {
                            SettingsData.shared.overlayBackgroundColor.value = overlayBackgroundColor.hex()
                            SnappingManager.shared.overlayWindow.colorUpdate()
                        }
                        .alignmentGuide(.leading) { d in
                            d[.leading]
                        }
                        .padding(5)
                    }
                }
                .padding(5)
                
                VStack {
                    Text("Preview:")
                    VStack {
                        if let wallpaper = Main.shared.wallpaper {
                            wallpaper
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle()
                        }
                    }
                    .frame(width: 320, height: 220)
                    .cornerRadius(8)
                    .overlay() {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(overlayBorderColor)
                        .fill(overlayBackgroundColor)
                        .frame(width: 180, height: 180)
                        .opacity(Double(overlayAlpha / 10))
                        .padding(5)
                    }
                }
            }
        }
        .frame(width: 650, height: 250)
        .padding(5)
    }
}

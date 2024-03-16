import SwiftUI
import HotKey

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
        .frame(width: 300, height: 150)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("enableShortcuts") private var enableShortcuts = true
    // @AppStorage("fontSize") private var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Shortcuts", isOn: $enableShortcuts)
        }
        // Form {
        //     Toggle("Show Previews", isOn: $showPreview)
        //     Slider(value: $fontSize, in: 9...96) {
        //         Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
        //     }
        // }
        // .padding(20)
    }
}

struct KeybindsSettingsView: View {
    //@AppStorage("shortcutsBindings") private var shortcutsBindings: Data

    var body: some View {
        Form {

        }
    }
}

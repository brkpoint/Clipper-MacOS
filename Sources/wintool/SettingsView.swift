import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("hello world!")
        }
        .onAppear { Main.shared.settingsWindowOpen = true }
        .onDisappear { Main.shared.settingsWindowOpen = false }
    }
} 

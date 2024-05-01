import SwiftUI
import KeyboardShortcuts

class WindowInfoView: ObservableObject {
    @Published var windowElement: WindowElement

    init(_ newWindowElement: WindowElement) {
        windowElement = newWindowElement
    }
}

struct MenuView: View {
    @StateObject private var windowInfo: WindowInfoView = WindowInfoView(WindowElement("", "", nil))
    
    @Environment(\.openSettings) var openSettings

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    Label {
                        Text(self.windowInfo.windowElement.name)
                    } icon: {
                        Image(nsImage: self.windowInfo.windowElement.icon)
                    }.font(.title)
                    ForEach(ResizeType.allCases.filter {$0.isBasic()}, id: \.self) { item in
                        Button(item.rawValue) {
                            WindowManager.shared.Align(item)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            windowInfo.windowElement = WindowManager.shared.currentApplication
        }
        .openSettingsAccess()
    }
}

struct MenuViewView_Previews:
    PreviewProvider {
    static var previews: some View {
        Main.shared.contentView
            .frame(width: 225, height: 150)
            .openSettingsAccess()
    }
}

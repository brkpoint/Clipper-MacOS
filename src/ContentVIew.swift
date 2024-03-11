import SwiftUI

class WindowInfoView: ObservableObject {
    @Published var window: WindowElement

    init(_ newWindow: WindowElement) {
        window = newWindow
    }
}

struct ContentView: View {
    let windowManager = WindowManager.shared
    @StateObject private var windowInfo: WindowInfoView = WindowInfoView(WindowElement("", ""))

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    HStack() {
                        Text("Align: \(self.windowInfo.window.name)")
                        Image(nsImage: self.windowInfo.window.icon)
                    }
                    ForEach(ResizeType.allCases.filter {$0.isBasic($0)}, id: \.self) { item in
                        Button(action: {
                            windowManager.Align(item)
                        }) {
                            Text(item.rawValue).foregroundColor(Color.primary)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear(perform: {
            windowInfo.window = WindowManager.shared.GetCurrentApp()
        })
    }
}

struct ContentView_Previews:
    PreviewProvider {
    static var previews: some View {
        Main.shared.contentView
    }
}

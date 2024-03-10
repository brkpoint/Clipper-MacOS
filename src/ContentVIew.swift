import SwiftUI

class WindowViewInfo: ObservableObject {
    @Published var appName: String

    init(_ name: String) {
        appName = name
    }
}

struct ContentView: View {
    let windowManager = WindowManager.shared
    @ObservedObject var viewInfo: WindowViewInfo = WindowViewInfo("None")

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    Text("Align app: \(self.viewInfo.appName)")                
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
    }
}

struct ContentView_Previews:
    PreviewProvider {
    static var previews: some View {
        Main.shared.contentView
    }
}

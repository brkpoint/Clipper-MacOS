import SwiftUI

class WindowInfoView: ObservableObject {
    @Published var appName: String

    init(_ newAppName: String) {
        appName = newAppName
    }
}

struct ContentView: View {
    let windowManager = WindowManager.shared
    @StateObject var windowInfoView: WindowInfoView = WindowInfoView("")

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    Text("Align: \(self.windowInfoView.appName)")                
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
            windowInfoView.appName = WindowManager.shared.GetCurrentApp().name
        })
    }
}

struct ContentView_Previews:
    PreviewProvider {
    static var previews: some View {
        Main.shared.contentView
    }
}

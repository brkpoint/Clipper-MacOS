import SwiftUI

struct ContentView: View {
    let windowManager = WindowManager.shared
    var appName: String = "None"

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    Text("Align: \(appName)")                
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

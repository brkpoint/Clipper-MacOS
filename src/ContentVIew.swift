import SwiftUI

struct ContentView: View {
    let windowManager = WindowManager()
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    Text("Align app \(windowManager.GetCurrentApp().name)")
                    ForEach(ResizeType.allCases, id: \.self) { item in
                        Button {
                            Task {
                                windowManager.Align(item)
                            }
                        } label: {
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
        ContentView()
    }
}

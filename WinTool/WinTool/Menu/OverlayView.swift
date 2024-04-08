import SwiftUI

struct OverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                Text("Full Screen Overlay")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("This is an example of a full screen overlay in macOS using Swift.")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    
                }) {
                    Text("Dismiss")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

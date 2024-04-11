import SwiftUI

struct OverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                Text("Full Screen Overlay")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

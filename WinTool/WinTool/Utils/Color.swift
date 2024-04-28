import Foundation
import Cocoa
import SwiftUI

extension Color {
    
    init(rgb: Int, a: Double = 1.0) {
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0,
            opacity: a
        )
    }
    
    func hex() -> Int {
        let resolved = self.resolve(in: Main.shared.environment)
        let r = Int(resolved.red * 255) << 16
        let g = Int(resolved.green * 255) << 8
        let b = Int(resolved.blue * 255)
        return Int(r | g | b)
    }
}

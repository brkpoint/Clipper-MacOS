import Foundation
import Cocoa
import SwiftUI

extension Color {
    init(_ rgb: Int) {
        self.init(red: Double((rgb >> 16) & 0xFF) / 255.0, green: Double((rgb >> 8) & 0xFF) / 255.0, blue: Double(rgb & 0xFF) / 255.0)
    }
    
    func hex() -> Int {
        let resolved = self.resolve(in: Main.shared.environment)
        let r = Int(resolved.red * 255) << 16
        let g = Int(resolved.green * 255) << 8
        let b = Int(resolved.blue * 255)
        return Int(r | g | b)
    }
}

extension NSColor {
    convenience init(_ rgb: Int) {
        self.init(Color(red: Double((rgb >> 16) & 0xFF) / 255.0, green: Double((rgb >> 8) & 0xFF) / 255.0, blue: Double(rgb & 0xFF) / 255.0))
    }
    
    func hex() -> Int {
        let r = Int(self.redComponent * 255) << 16
        let g = Int(self.greenComponent * 255) << 8
        let b = Int(self.blueComponent * 255)
        return Int(r | g | b)
    }
}

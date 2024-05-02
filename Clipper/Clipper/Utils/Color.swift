import Foundation
import Cocoa
import SwiftUI

extension Color {
    init(_ rgb: Int) {
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b, opacity: 1.0)
    }
    
    func hex() -> Int {
        let resolved = self.resolve(in: Main.shared.environment)
        return toHex(r: resolved.red, g: resolved.green, b: resolved.blue)
    }
}

extension NSColor {
    convenience init(_ rgb: Int) {
        self.init(Color(rgb))
    }
    
    func hex() -> Int {
        return toHex(r: Float(self.redComponent), g: Float(self.greenComponent), b: Float(self.blueComponent))
    }
}

func toHex(r: Float, g: Float, b: Float) -> Int {
    let rh = Int(r * 255)
    let gh = Int(g * 255)
    let bh = Int(b * 255)
    return (rh << 16) | (gh << 8) | bh
}

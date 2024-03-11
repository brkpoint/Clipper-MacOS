import Foundation
import SwiftUI

struct WindowElement {
    let name: String
    let Id: String
    let window: NSWindow
    let icon: NSImage
    init(_ Name: String, _ ID: String) {
        name = Name
        Id = ID
        window = NSWindow()
        icon = NSImage()
    }

    init(_ Name: String, _ title: String , _ ID: String, _ Icon: NSImage, _ Window: NSWindow) {
        name = Name
        Id = ID
        window = Window
        icon = Icon
    }
    
}

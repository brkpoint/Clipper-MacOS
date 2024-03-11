import Foundation
import SwiftUI

struct WindowElement {
    let name: String
    let Id: String
    let icon: NSImage
    init(_ n: String, _ ID: String) {
        name = n
        Id = ID
        icon = NSImage()
    }

    init(_ n: String, _ ID: String, _ Icon: NSImage) {
        name = n
        Id = ID
        icon = Icon
    }
    
}

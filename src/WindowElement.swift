import Foundation
import SwiftUI

class WindowElement {
    let name: String
    let Id: String
    let icon: NSImage

    fileprivate let axUIElement: AXUIElement

    convenience init(_ Name: String, _ ID: String, _ PID: pid_t) {
        self.init(Name, ID, PID, NSImage())
    }

    init(_ Name: String, _ ID: String, _ PID: pid_t, _ Icon: NSImage) {
        name = Name
        Id = ID
        icon = Icon

        axUIElement = AXUIElementCreateApplication(PID)
    }

    private var position: CGPoint? {
        get {
            axUIElement.getWrappedValue(.position)
        }
        set {
            guard let newValue = newValue else { return }
            axUIElement.setValue(.position, newValue)
        }
    }

    private var size: CGSize? {
        get {
            axUIElement.getWrappedValue(.size)
        }
        set {
            guard let newValue = newValue else { return }
            axUIElement.setValue(.size, newValue)
        }
    }

    var frame: CGRect {
        guard let position = position, let size = size else { return .null }
        return .init(origin: position, size: size)
    }

    func setFrame(_ nFrame: CGRect) {
        axUIElement.setValue(.size, CGSize(width: 800, height: 600))
        print(axUIElement.getValue(.size))
    }
    
}

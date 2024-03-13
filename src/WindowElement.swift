import Foundation
import SwiftUI

class WindowElement {
    let name: String
    let Id: String
    let icon: NSImage

    fileprivate var axUIElement: Optional<AXUIElement>
    private let mainApp: AXUIElement

    convenience init(_ Name: String, _ ID: String, _ PID: pid_t) {
        self.init(Name, ID, PID, NSImage())
    }

    init(_ Name: String, _ ID: String, _ PID: pid_t, _ Icon: NSImage) {
        name = Name
        Id = ID
        icon = Icon

        mainApp = AXUIElementCreateApplication(PID)
        axUIElement = nil
    }

    private var position: CGPoint? {
        get {
            axUIElement?.getWrappedValue(.position)
        }
        set {
            guard let newValue = newValue else { return }
            axUIElement?.setValue(.position, newValue)
        }
    }

    private var size: CGSize? {
        get {
            axUIElement?.getWrappedValue(.size)
        }
        set {
            guard let newValue = newValue else { return }
            axUIElement?.setValue(.size, newValue)
        }
    }

    var isResizable: Bool {
        get {
            axUIElement?.isSettable(.size) ?? true
        }
    }

    var frame: CGRect {
        guard let position = position, let size = size else { return .null }
        return .init(origin: position, size: size)
    }

    func setFrame(_ nFrame: CGRect) {
        if !isResizable {
            return
        }

        position = nFrame.origin
        size = nFrame.size

        print("INFO: Resizing window: \(axUIElement?.getValue(.title) as? String ?? "N/A"), to rect: \(nFrame)")
    }

    func getWindow() {
        axUIElement = mainApp.getValue(.focusedWindow) as! AXUIElement
    }
    
}

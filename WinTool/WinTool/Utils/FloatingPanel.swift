import SwiftUI

class FloatingPanel<Content: View>: NSPanel {
    init(content: Content) {
        self.content = content
        super.init(contentRect: .zero, styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        self.level = .floating
        self.isOpaque = false
        self.hasShadow = false
        self.becomesKeyOnlyIfNeeded = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var content: Content
}

import SwiftUI
import KeyboardShortcuts

struct Shortcut: Hashable, Identifiable {
    let id: UUID
    var name: KeyboardShortcuts.Name
    var title: String

    init(_ name: KeyboardShortcuts.Name, _ title: String) {
        id = UUID()
        self.name = name
        self.title = title
    }
}

class Shortcuts: ObservableObject {
    @Published var list: [Shortcut] = []
}

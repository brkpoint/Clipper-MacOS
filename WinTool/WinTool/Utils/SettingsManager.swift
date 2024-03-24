import Foundation
import SwiftUI

struct AppSetting {
    var name: String
    var value: Bool {
        didSet {
            UserDefaults.standard.set(self.value, forKey: userDefaultsKey)
        }
    }
    let userDefaultsKey: String
    
    init(_ name: String) {
        userDefaultsKey = Main.shared.userDefaultsKey + name
        
        self.name = name
        self.value = UserDefaults.standard.bool(forKey: userDefaultsKey)
    }
}

struct SettingsManager {
    static var shared: SettingsManager = SettingsManager()
    
    var shortcutsEnabled = AppSetting("snappingEnabled")
    var snappingEnabled = AppSetting("snappingEnabled")
}

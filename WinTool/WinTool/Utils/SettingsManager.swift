import Foundation
import Cocoa
import SwiftUI

struct AppSetting<T> {
    var name: String
    var value: T {
        didSet {
            UserDefaults.standard.set(self.value, forKey: userDefaultsKey)
        }
    }
    
    let userDefaultsKey: String
    
    init(_ name: String) {
        userDefaultsKey = Main.shared.userDefaultsKey + name
        
        self.name = name
        self.value = UserDefaults.standard.object(forKey: userDefaultsKey) as? T ?? 0 as! T
    }
    
    init(_ name: String, _ defaultVal: T) {
        userDefaultsKey = Main.shared.userDefaultsKey + name
        
        self.name = name
        self.value = defaultVal
    }
}

struct SettingsManager {
    static var shared: SettingsManager = SettingsManager()
    
    var shortcutsEnabled = AppSetting<Bool>("shortcutsEnabled", true)
    
    var snappingEnabled = AppSetting<Bool>("snappingEnabled", true)
    
    var overlayAlpha = AppSetting<CGFloat>("overlayAlpha", 45)
    var overlayCornerRadius = AppSetting<CGFloat>("overlayCornerRadius", 10)
    var overlayBorderColor = AppSetting<Int>("overlayBorderColor", Color(NSColor.controlAccentColor).hex())
    var overlayBackgroundColor = AppSetting<Int>("overlayBackgroundColor", Color(NSColor.controlBackgroundColor).hex())
}

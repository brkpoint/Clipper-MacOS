import Foundation
import Cocoa
import SwiftUI

struct AppSetting<T> {
    var name: String
    var defaultValue: T
    var value: T {
        didSet {
            UserDefaults.standard.set(self.value, forKey: userDefaultsKey)
        }
    }
    
    let userDefaultsKey: String
    
    init(_ name: String) {
        userDefaultsKey = Main.shared.userDefaultsKey + name
        
        self.name = name
        self.defaultValue = 0 as! T
        self.value = UserDefaults.standard.object(forKey: userDefaultsKey) as? T ?? 0 as! T
    }
    
    init(_ name: String, _ defaultVal: T) {
        userDefaultsKey = Main.shared.userDefaultsKey + name
        
        self.name = name
        self.defaultValue = defaultVal
        if let val = UserDefaults.standard.object(forKey: userDefaultsKey) as? T {
            self.value = val
            return
        }
        
        self.value = defaultVal
    }
    
    mutating func reset() {
        value = defaultValue
    }
}

struct SettingsManager {
    static var shared: SettingsManager = SettingsManager()
    
    var shortcutsEnabled = AppSetting<Bool>("shortcutsEnabled", true)
    
    var snappingEnabled = AppSetting<Bool>("snappingEnabled", true)
    
    var timeToSnap = AppSetting<Double>("timeToSnap", 0.45)
    
    var overlayAlpha = AppSetting<CGFloat>("overlayAlpha", 30)
    var overlayBorderColor = AppSetting<Int>("overlayBorderColor", Color(NSColor.controlColor).hex())
    var overlayBackgroundColor = AppSetting<Int>("overlayBackgroundColor", Color(NSColor.controlAccentColor).hex())
}

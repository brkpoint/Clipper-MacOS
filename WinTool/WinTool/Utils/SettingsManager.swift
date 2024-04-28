import Foundation
import SwiftUI

struct AppSetting<T> {
    var name: String
    var value: T {
        didSet {
            UserDefaults.standard.set(self.value, forKey: userDefaultsKey) as! T
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
    
    func test() {
        print(T.self)
    }
}

struct SettingsManager {
    static var shared: SettingsManager = SettingsManager()
    
    var shortcutsEnabled = AppSetting<Bool>("shortcutsEnabled", true)
    var snappingEnabled = AppSetting<Bool>("snappingEnabled", true)
    var overlayCornerRadius = AppSetting<Int>("overlayCornerRadius", 10)
}

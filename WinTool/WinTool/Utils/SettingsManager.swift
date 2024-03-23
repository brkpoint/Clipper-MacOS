import Foundation

struct AppSetting {
    var name: String
    var value: Any
    var userDefaultsKey: String
    
    init(_ name: String, _ value: Any) {
        self.name = name
        self.value = value
        
        userDefaultsKey = SettingsManager.shared.userDefaultsKey + name
    }
}

struct SettingsManager {
    static var shared: SettingsManager = SettingsManager()
    let userDefaultsKey = "setting."
    
    var shortcutsEnabled = AppSetting("snappingEnabled", true)
    var snappingEnabled = AppSetting("snappingEnabled", true)
}

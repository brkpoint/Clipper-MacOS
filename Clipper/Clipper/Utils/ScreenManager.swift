import Foundation
import Cocoa
import SwiftUI

class ScreenManager {
    static var shared: ScreenManager = ScreenManager()
    
    private var screen: NSScreen = NSScreen()
    
    func GetScreen() -> NSScreen {
        return screen
    }
    
    func UpdateScreen() {
        screen = NSScreen.main ?? screen
    }
}

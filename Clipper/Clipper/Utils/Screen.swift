import Foundation
import Cocoa
import SwiftUI

class ScreenManager {
    static var shared: ScreenManager = ScreenManager()
    
    var screen: NSScreen = NSScreen()
    
    func UpdateScreen() {
        screen = NSScreen.main ?? screen
    }
}

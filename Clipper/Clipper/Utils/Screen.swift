import Foundation
import Cocoa
import SwiftUI

class Screen {
    static var shared: Screen = Screen()
    
    var screen: NSScreen = NSScreen()
    
    func UpdateScreen() {
        screen = NSScreen.main ?? screen
    }
}

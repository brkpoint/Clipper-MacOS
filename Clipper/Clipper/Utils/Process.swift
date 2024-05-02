import Cocoa

class Process {
    static func askForAccessibilityIfNeeded() {
        if !isAllowedToUseAccessibilty() {
            print("INFO: Asking for permission to access other apps")
            AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue():true] as CFDictionary)
            return
        }
        print("INFO: App has permissions to access other apps")
    }
    
    static func isAllowedToUseAccessibilty() -> Bool {
        return AXIsProcessTrusted()
    }
    
    static func isSandboxingEnabled() -> Bool {
        return ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
    }
}

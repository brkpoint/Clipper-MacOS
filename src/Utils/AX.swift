import Cocoa

extension AXUIElement {
    func getValue(_ attribute: NSAccessibility.Attribute) -> AnyObject? {
        var value: AnyObject?
        let result = AXUIElementCopyAttributeValue(self, attribute.rawValue as CFString, &value)
        guard result == .success else { return nil }
        return value
    }

    func getWrappedValue<T>(_ attribute: NSAccessibility.Attribute) -> T? {
        guard let value = getValue(attribute), CFGetTypeID(value) == AXValueGetTypeID() else { return nil }
        return (value as! AXValue).convertTo()
    }

    private func m_setValue(_ attribute: NSAccessibility.Attribute, _ value: AnyObject) {
        AXUIElementSetAttributeValue(self, attribute.rawValue as CFString, value)
    }

    private func m_setWrappedValue<T>(_ attribute: NSAccessibility.Attribute, _ value: T, _ type: AXValueType) {
        guard let value = AXValue.convertFrom(value, type) else { return }
        m_setValue(attribute, value)
    }

    func setValue(_ attribute: NSAccessibility.Attribute, _ value: Bool) {
        m_setValue(attribute, value as CFBoolean)
    }

    func setValue(_ attribute: NSAccessibility.Attribute, _ value: CGPoint) {
        m_setWrappedValue(attribute, value, .cgPoint)
    }
    
    func setValue(_ attribute: NSAccessibility.Attribute, _ value: CGSize) {
        m_setWrappedValue(attribute, value, .cgSize)
    }

    func isSettable(_ attribute: NSAccessibility.Attribute) -> Bool {
        var attributeCanBeSet: DarwinBoolean = false
        AXUIElementIsAttributeSettable(self, attribute.rawValue as CFString, &attributeCanBeSet)
        return attributeCanBeSet.boolValue
    }

    static func askForAccessibilityIfNeeded() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        print("INFO: Asking for permission to access other apps")
        return AXIsProcessTrustedWithOptions(options as CFDictionary?)
    }
    
    static func checkAppIsAllowToUseAccessibilty() -> Bool {
        return AXIsProcessTrusted()
    }
    
    static func isSandboxingEnabled() -> Bool {
        let environment = ProcessInfo.processInfo.environment
        return environment["APP_SANDBOX_CONTAINER_ID"] != nil
    }
}

extension AXValue {
    func convertTo<T>() -> T? {
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        let success = AXValueGetValue(self, AXValueGetType(self), pointer)
        let value = pointer.pointee
        pointer.deallocate()
        return success ? value : nil
    }
    
    static func convertFrom<T>(_ value: T, _ type: AXValueType) -> AXValue? {
        var value = value
        return AXValueCreate(type, &value)
    }
}

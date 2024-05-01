import Cocoa

// for debugging remove the commented lines
// (for some apps it will always return an error e.g. -25212 (no value)

extension AXUIElement {
    func getValue(_ attribute: NSAccessibility.Attribute) -> AnyObject? {
        var value: AnyObject?
        let result = AXUIElementCopyAttributeValue(self, attribute.rawValue as CFString, &value)
        guard result == .success else {
            //print("ERR: \(result.rawValue)")
            return nil
        }
        return value
    }

    func getWrappedValue<T>(_ attribute: NSAccessibility.Attribute) -> T? {
        guard let value = getValue(attribute), CFGetTypeID(value) == AXValueGetTypeID() else {
            return nil
        }
        return (value as! AXValue).convertTo()
    }

    private func m_setValue(_ attribute: NSAccessibility.Attribute, _ value: AnyObject) {
        let error = AXUIElementSetAttributeValue(self, attribute.rawValue as CFString, value)
        guard error == .success else {
            //print("ERR: AXSetValue - err_code: \(error.rawValue)")
            return
        }
    }

    private func m_setWrappedValue<T>(_ attribute: NSAccessibility.Attribute, _ value: T, _ type: AXValueType) {
        guard let value = AXValue.convertFrom(value, type) else {
            return
        }
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
}

extension AXValue {
    func convertTo<T>() -> T? {
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        let success = AXValueGetValue(self, AXValueGetType(self), pointer)
        let value = pointer.pointee
        pointer.deallocate()
        if !success {
            //print("ERR: AXValue error")
            return nil
        }
        return value
    }
    
    static func convertFrom<T>(_ value: T, _ type: AXValueType) -> AXValue? {
        var value = value
        return AXValueCreate(type, &value)
    }
}

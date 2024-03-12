import Cocoa

extension AXUIElement {
    func getValue(_ attribute: NSAccessibility.Attribute) -> AnyObject? {
        var result: AnyObject?
        let error = AXUIElementCopyAttributeValue(self, attribute.rawValue as CFString, &result)
        guard error == .success else { return nil }
        return result
    }

    func getWrappedValue<T>(_ attribute: NSAccessibility.Attribute) -> T? {
        guard let value = getValue(attribute), CFGetTypeID(value) == AXValueGetTypeID() else {
            return nil
        }

        return (value as! AXValue).convertTo()
    }

    private func m_SetValue(_ attribute: NSAccessibility.Attribute, _ value: AnyObject) {
        AXUIElementSetAttributeValue(self, attribute.rawValue as CFString, value)
    }

    private func m_SetWrappedValue<T>(_ attribute: NSAccessibility.Attribute, _ value: T, _ type: AXValueType) {
        guard let value = AXValue.convertFrom(value, type) else {
            return
        }
        m_SetValue(attribute, value)
    }

    func setValue(_ attribute: NSAccessibility.Attribute, _ value: Bool) {
        m_SetValue(attribute, value as CFBoolean)
    }

    func setValue(_ attribute: NSAccessibility.Attribute, _ value: CGPoint) {
        m_SetWrappedValue(attribute, value, .cgPoint)
    }
    
    func setValue(_ attribute: NSAccessibility.Attribute, _ value: CGSize) {
        m_SetWrappedValue(attribute, value, .cgSize)
    }
}

extension AXValue {
    func convertTo<T>() -> T? {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: 1)
        let error = AXValueGetValue(self, AXValueGetType(self), ptr)
        let ptrValue = ptr.pointee
        ptr.deallocate()

        return error ? ptrValue : nil
    }

    static func convertFrom<T>(_ value: T, _ type: AXValueType) -> AXValue? {
        var value = value
        return AXValueCreate(type, &value)
    }
}

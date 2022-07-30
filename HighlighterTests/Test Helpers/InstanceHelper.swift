public extension InstanceHelper {
    static func create<T:AnyObject>(_ clazz: T.Type, properties: [String: Any] = [:]) throws -> T {
        if let instance = InstanceHelper.createInstance(clazz, properties: properties) as? T {
            return instance
        }
        throw NSError(domain: "InstanceHelper", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot create instance of \(clazz)"])
    }
}

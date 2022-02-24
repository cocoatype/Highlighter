//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Combine
import Foundation

extension Defaults {
    @propertyWrapper public struct Value<ValueType> {
        public var wrappedValue: ValueType {
            get {
                Self.object(for: key, fallback: fallback)
            }
            nonmutating set {
                Self.userDefaults.set(newValue, forKey: key.rawValue)
                NotificationCenter.default.post(name: valueDidChange, object: nil)
            }
        }

        public init(key: Defaults.Key, fallback: ValueType) {
            self.key = key
            self.fallback = fallback
            self.publisher = CurrentValueSubject<ValueType, Never>(Self.object(for: key, fallback: fallback))

        }

        public init(key: Defaults.Key) where ValueType == Bool {
            self.init(key: key, fallback: false)
        }

        public init(key: Defaults.Key) where ValueType == Int {
            self.init(key: key, fallback: 0)
        }

        public init<ElementType>(key: Defaults.Key) where ValueType == Array<ElementType> {
            self.init(key: key, fallback: [])
        }

        private let key: Defaults.Key
        private let fallback: ValueType

        // MARK: Projected Value
        
        public var projectedValue: CurrentValueSubject<ValueType, Never> {
            return publisher
        }

        private let publisher: CurrentValueSubject<ValueType, Never>


        // MARK: Boilerplate

        private static func object(for key: Key, fallback: ValueType) -> ValueType {
            guard let object = Self.userDefaults.object(forKey: key.rawValue) as? ValueType else { return fallback }
            return object
        }

        public var valueDidChange: Notification.Name {
            Notification.Name("Defaults.valueDidChange.\(key.rawValue)")
        }

        private static var userDefaults: UserDefaults {
            return UserDefaults.standard
        }
    }
}

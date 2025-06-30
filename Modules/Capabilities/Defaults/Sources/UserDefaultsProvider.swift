//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

struct UserDefaultsProvider: DefaultsProvider {
    init(
        userDefaults: UserDefaults,
        notificationCenter: NotificationCenter = .default
    ) {
        self.userDefaults = userDefaults
        self.notificationCenter = notificationCenter
    }

    func value(for key: Key<Bool>) -> Bool {
        userDefaults.bool(forKey: key.value)
    }

    func set(_ value: Bool, for key: Key<Bool>) {
        userDefaults.set(value, forKey: key.value)
        notificationCenter.post(name: key.valueDidChange, object: self)
    }

    func value(for key: Key<Int>) -> Int {
        userDefaults.integer(forKey: key.value)
    }

    func set(_ value: Int, for key: Key<Int>) {
        userDefaults.set(value, forKey: key.value)
        notificationCenter.post(name: key.valueDidChange, object: self)
    }

    func value(for key: Key<String>) -> String? {
        userDefaults.string(forKey: key.value)
    }

    func set(_ value: String, for key: Key<String>) {
        userDefaults.set(value, forKey: key.value)
        notificationCenter.post(name: key.valueDidChange, object: self)
    }

    func value<Value: DefaultsRepresentable>(for key: Key<Value>) -> Value? {
        userDefaults.object(forKey: key.value) as? Value
    }

    func set<Value: DefaultsRepresentable>(_ value: Value, for key: Key<Value>) {
        userDefaults.set(value, forKey: key.value)
        notificationCenter.post(name: key.valueDidChange, object: self)
    }

    // MARK: - Test Hooks

    let userDefaults: UserDefaults
    private let notificationCenter: NotificationCenter
}

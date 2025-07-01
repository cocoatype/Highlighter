//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

import TestHelpers

@testable import Defaults

@MainActor
struct UserDefaultsProviderTests {
    @Test("value(for:) returns string value from UserDefaults")
    func valueForStringKeyReturnsValue() async throws {
        let keyValue = "key"
        let key = Key<String>(value: keyValue)
        let userDefaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        userDefaults.set("test", forKey: keyValue)
        let provider = UserDefaultsProvider(userDefaults: userDefaults)

        #expect(await provider.value(for: key) == "test")
    }

    @Test("value(for:) returns nil value for string key if not set")
    func valueForStringKeyReturnsNilIfNotSet() async throws {
        let keyValue = "key"
        let key = Key<String>(value: keyValue)
        let userDefaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        let provider = UserDefaultsProvider(userDefaults: userDefaults)

        #expect(await provider.value(for: key) == nil)
    }

    @Test("set(_:for:) sets value for string key")
    func setValueForStringKeySetsValue() async throws {
        let keyValue = "key"
        let key = Key<String>(value: keyValue)
        let userDefaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        let provider = UserDefaultsProvider(userDefaults: userDefaults)

        provider.set("test", for: key)
        let value = provider.userDefaults.string(forKey: keyValue)
        #expect(value == "test")
    }

    @Test("value(for:) returns bool value from UserDefaults")
    func valueForBoolKeyReturnsValue() async throws {
        let keyValue = "key"
        let key = Key<Bool>(value: keyValue)
        let userDefaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        userDefaults.set(true, forKey: keyValue)
        let provider = UserDefaultsProvider(userDefaults: userDefaults)

        #expect(await provider.value(for: key) == true)
    }

    @Test("value(for:) returns false for bool key if not set")
    func valueForBoolKeyReturnsFalseIfNotSet() async throws {
        let keyValue = "key"
        let key = Key<Bool>(value: keyValue)
        let userDefaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        let provider = UserDefaultsProvider(userDefaults: userDefaults)

        #expect(await provider.value(for: key) == false)
    }

    @Test("set(_:for:) sets value for bool key")
    func setValueForBoolKeySetsValue() async throws {
        let keyValue = "key"
        let key = Key<Bool>(value: keyValue)
        let userDefaults = try #require(UserDefaults(suiteName: UUID().uuidString))
        let provider = UserDefaultsProvider(userDefaults: userDefaults)

        provider.set(true, for: key)
        let value = provider.userDefaults.bool(forKey: keyValue)
        #expect(value == true)
    }
}

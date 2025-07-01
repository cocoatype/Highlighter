//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

@testable import Defaults

public class StubDefaultsProvider: DefaultsProvider {
    private var backingData = [String: Any]()
    public init(
        autoRedactions: [String: Bool] = [:],
        hideAutoRedactions: Bool = false,
        hideDocumentScanner: Bool = false,
        numberOfSaves: Int = 0
    ) {
        backingData[Keys.autoRedactionsSet.value] = autoRedactions
        backingData[Keys.hideAutoRedactions.value] = hideAutoRedactions
        backingData[Keys.hideDocumentScanner.value] = hideDocumentScanner
        backingData[Keys.numberOfSaves.value] = numberOfSaves
    }

    public func value(for key: Key<String>) -> String? {
        backingData[key.value] as? String
    }

    public func set(_ value: String, for key: Key<String>) {
        backingData[key.value] = value
    }

    public func value(for key: Key<Bool>) -> Bool {
        backingData[key.value] as? Bool ?? false
    }

    public func set(_ value: Bool, for key: Key<Bool>) {
        backingData[key.value] = value
    }

    public func value(for key: Key<Int>) -> Int {
        backingData[key.value] as? Int ?? 0
    }

    public func set(_ value: Int, for key: Key<Int>) {
        backingData[key.value] = value
    }

    public func value<Value>(for key: Key<Value>) -> Value? where Value: DefaultsRepresentable {
        backingData[key.value] as? Value
    }

    public func set<Value>(_ value: Value, for key: Key<Value>) where Value: DefaultsRepresentable {
        backingData[key.value] = value
    }
}

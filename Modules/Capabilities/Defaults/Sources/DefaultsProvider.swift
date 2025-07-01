//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

@MainActor
public protocol DefaultsProvider {
    func value(for key: Key<Bool>) -> Bool
    func set(_ value: Bool, for key: Key<Bool>)

    func value(for key: Key<Int>) -> Int
    func set(_ value: Int, for key: Key<Int>)

    func value(for key: Key<String>) -> String?
    func set(_ value: String, for key: Key<String>)

    func value<Value: DefaultsRepresentable>(for key: Key<Value>) -> Value?
    func set<Value: DefaultsRepresentable>(_ value: Value, for key: Key<Value>)
}

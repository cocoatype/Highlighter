//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

struct PreviewDefaultsProvider: DefaultsProvider {
    func value(for key: Key<Bool>) -> Bool { false }
    func set(_ value: Bool, for key: Key<Bool>) {}
    func value(for key: Key<Int>) -> Int { 0 }
    func set(_ value: Int, for key: Key<Int>) {}
    func value(for key: Key<String>) -> String? { nil }
    func set(_ value: String, for key: Key<String>) {}
    func value<Value: DefaultsRepresentable>(for key: Key<Value>) -> Value? { nil }
    func set<Value: DefaultsRepresentable>(_ value: Value, for key: Key<Value>) {}
}

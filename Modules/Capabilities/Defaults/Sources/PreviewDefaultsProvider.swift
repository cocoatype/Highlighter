//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public struct PreviewDefaultsProvider {
    public init() {}

    public func value(for key: Key<Bool>) -> Bool { false }
    public func set(_ value: Bool, for key: Key<Bool>) {}
    public func value(for key: Key<Int>) -> Int { 0 }
    public func set(_ value: Int, for key: Key<Int>) {}
    public func value(for key: Key<String>) -> String? { nil }
    public func set(_ value: String, for key: Key<String>) {}
    public func value<Value: DefaultsRepresentable>(
        for key: Key<Value>
    ) -> Value? { nil }
    public func set<Value: DefaultsRepresentable>(
        _ value: Value,
        for key: Key<Value>
    ) {}
}

//  Created by Geoff Pado on 5/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public extension NotificationCenter {
    func addObserver<ValueType: DefaultsRepresentable>(
        for key: Key<ValueType>,
        provider: (any DefaultsProvider)? = nil,
        block: @MainActor @escaping @Sendable () -> Void
    ) -> any NSObjectProtocol {
        addObserver(forName: key.valueDidChange, object: provider, queue: .main, using: { _ in
            Task { @MainActor in
                block()
            }
        })
    }
}

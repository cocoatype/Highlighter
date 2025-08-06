//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Synchronization

import AppNavigation

@available(iOS 18, *)
public final class SpyNavigator: Navigator {
    public init() {}

    private let routeMutex = Mutex<Route?>(nil)
    public var route: Route? {
        get {
            return routeMutex.withLock { $0 }
        }
        set {
            routeMutex.withLock { @MainActor value in
                value = newValue
            }
        }
    }

    public func navigate(to route: Route) {
        self.route = route
    }
}

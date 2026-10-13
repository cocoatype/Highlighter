//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppNavigation

@available(iOS 18, *)
public final class SpyNavigator: Navigator {
    public init() {}

    public private(set) var route: Route?

    public func navigate(to route: Route) {
        self.route = route
    }
}

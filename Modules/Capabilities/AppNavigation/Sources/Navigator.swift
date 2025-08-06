//  Created by Geoff Pado on 6/14/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

@MainActor public protocol Navigator: Sendable {
    func navigate(to route: Route)
}

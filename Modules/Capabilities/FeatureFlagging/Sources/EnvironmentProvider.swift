//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

struct EnvironmentProvider: FeatureFlagProvider {
    private let environment: [String: String]
    init(
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) {
        self.environment = environment
    }

    var shouldShowDebugOverlay: Bool {
        environment["SHOW_DEBUG_OVERLAY"].isTruthy
    }
}

//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import FeatureFlags

struct EnvironmentProviderTests {
    @Test
    func shouldShowDebugOverlay() {
        let trueProvider = EnvironmentProvider(environment: ["SHOW_DEBUG_OVERLAY": "true"])
        let falseProvider = EnvironmentProvider(environment: [:])

        #expect(trueProvider.shouldShowDebugOverlay == true)
        #expect(falseProvider.shouldShowDebugOverlay == false)
    }
}

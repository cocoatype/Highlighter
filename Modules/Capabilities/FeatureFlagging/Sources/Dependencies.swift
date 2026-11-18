//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import FactoryKit

public extension Container {
    var featureFlagProvider: Factory<any FeatureFlagProvider> {
        Factory(self) {
            EnvironmentProvider()
        }
    }
}

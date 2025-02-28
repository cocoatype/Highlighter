//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public enum FeatureFlagging {
    public static let provider: any FeatureFlagProvider = EnvironmentProvider()
}

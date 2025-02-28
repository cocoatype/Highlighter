//  Created by Geoff Pado on 12/6/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

public protocol FeatureFlagProvider: Sendable {
    var shouldShowDebugOverlay: Bool { get }
}

//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import GeometryMac
#elseif canImport(UIKit)
import Geometry
#endif

import CoreGraphics
import Testing

@testable import Observations

struct TextObservationTests {
    struct StubObservation: TextObservation {
        let bounds = Shape.sample
    }

    @Test func path() {
        let observation = StubObservation()
        #expect(observation.path == observation.bounds.path)
    }
}

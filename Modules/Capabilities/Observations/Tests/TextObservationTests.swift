//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

import Geometry

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

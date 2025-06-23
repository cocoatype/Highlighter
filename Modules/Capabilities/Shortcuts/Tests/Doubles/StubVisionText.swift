//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Vision

import Observations

struct MockVisionText: VisionText {
    init(_ string: String) {
        self.string = string
    }

    let string: String

    func boundingBox(for range: Range<String.Index>) throws -> VNRectangleObservation? {
        VNRectangleObservation(boundingBox: .zero)
    }
}

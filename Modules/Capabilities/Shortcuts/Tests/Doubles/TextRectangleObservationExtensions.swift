//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing
import UIKit
import Vision

import struct Observations.TextRectangleObservation

extension TextRectangleObservation {
    init(_ string: String) throws {
        let sampleImage = try #require(UIImage(systemName: "bolt"))
        self.init(
            VNTextObservation(boundingBox: .zero),
            in: sampleImage
        )
    }
}

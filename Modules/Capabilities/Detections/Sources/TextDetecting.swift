//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import struct Observations.RecognizedTextObservation
import struct Observations.TextRectangleObservation

public protocol TextDetecting: Sendable {
    func recognizeText(in image: DetectableImage) async throws -> [RecognizedTextObservation]
    func detectText(in image: DetectableImage) async throws -> [TextRectangleObservation]
}

extension TextDetector: TextDetecting {}

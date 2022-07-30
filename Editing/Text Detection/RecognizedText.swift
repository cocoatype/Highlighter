//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Vision

struct RecognizedText: Equatable {
    let recognizedText: VisionText
    let uuid: UUID

    var string: String { recognizedText.string }

    init(recognizedText: VisionText, uuid: UUID) {
        self.recognizedText = recognizedText
        self.uuid = uuid
    }

    static func ==(lhs: RecognizedText, rhs: RecognizedText) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

protocol VisionText {
    func boundingBox(for range: Range<String.Index>) throws -> VNRectangleObservation?
    var string: String { get }
}

extension VNRecognizedText: VisionText {}

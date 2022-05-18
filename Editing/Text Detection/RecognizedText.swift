//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Vision

struct RecognizedText: Equatable {
    let recognizedText: VNRecognizedText
    let uuid: UUID

    var string: String { recognizedText.string }

    static func ==(lhs: RecognizedText, rhs: RecognizedText) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

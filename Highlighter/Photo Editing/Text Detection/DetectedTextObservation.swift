//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

struct DetectedTextObservation: Equatable {
    init(_ textObservation: VNTextObservation, in image: UIImage) {
        let boundingBox = textObservation.boundingBox
        let imageSize = image.size * image.scale
        self.bounds = CGRect.flippedRect(from: boundingBox, scaledTo: imageSize)

        self.characterObservations = textObservation.characterBoxes?.map {
            DetectedCharacterObservation(bounds: CGRect.flippedRect(from: $0.boundingBox, scaledTo: imageSize))
        }
    }

    let bounds: CGRect
    let characterObservations: [DetectedCharacterObservation]?
}

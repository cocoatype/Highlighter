//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

public struct TextObservation: Equatable {
    init(_ textObservation: VNTextObservation, in image: UIImage) {
        let boundingBox = textObservation.boundingBox
        let imageSize = image.size * image.scale
        self.bounds = CGRect.flippedRect(from: boundingBox, scaledTo: imageSize)

        let observationUUID = textObservation.uuid
        self.uuid = observationUUID

        self.characterObservations = textObservation.characterBoxes?.map {
            CharacterObservation(bounds: CGRect.flippedRect(from: $0.boundingBox, scaledTo: imageSize), textObservationUUID: observationUUID)
        }
    }

    let bounds: CGRect
    let characterObservations: [CharacterObservation]?
    let uuid: UUID
}

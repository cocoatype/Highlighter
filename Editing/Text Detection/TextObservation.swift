//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

public struct TextObservation: Equatable {
    init(_ rectangleObservation: VNRectangleObservation, in image: UIImage, characterObservations: [CharacterObservation]? = nil) {
        let boundingBox = rectangleObservation.boundingBox
        let imageSize = image.size * image.scale
        self.bounds = CGRect.flippedRect(from: boundingBox, scaledTo: imageSize)
        self.uuid = rectangleObservation.uuid
        self.characterObservations = characterObservations
    }

    init(_ textObservation: VNTextObservation, in image: UIImage) {
        let imageSize = image.size * image.scale
        let characterObservations = textObservation.characterBoxes?.map {
            CharacterObservation(bounds: CGRect.flippedRect(from: $0.boundingBox, scaledTo: imageSize), textObservationUUID: textObservation.uuid)
        }
        self.init(textObservation, in: image, characterObservations: characterObservations)
    }

    let bounds: CGRect
    let characterObservations: [CharacterObservation]?
    let uuid: UUID
}

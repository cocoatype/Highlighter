//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Geometry
import UIKit

import Vision

public struct TextRectangleObservation: TextObservation, RedactableObservation, Sendable {
    public init(_ textObservation: VNTextObservation, in image: UIImage) {
        let imageSize = image.size * image.scale
        self.init(textObservation, scaledTo: imageSize)
    }

    public init(_ textObservation: VNTextObservation, scaledTo imageSize: CGSize) {
        self.bounds = Shape(textObservation).scaled(to: imageSize)

        let characterObservations = textObservation.characterBoxes?.map {
            CharacterObservation(bounds: Shape($0).scaled(to: imageSize), textObservationUUID: textObservation.uuid)
        }

        self.characterObservations = characterObservations ?? []
    }

    public let bounds: Shape
    public let characterObservations: [CharacterObservation]
}

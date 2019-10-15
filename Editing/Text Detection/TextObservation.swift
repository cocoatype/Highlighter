//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

public protocol TextObservation: Equatable {
    var bounds: CGRect { get }
}

public struct TextRectangleObservation: TextObservation {
    init(_ textObservation: VNTextObservation, in image: UIImage) {
        let boundingBox = textObservation.boundingBox
        let imageSize = image.size * image.scale
        self.bounds = CGRect.flippedRect(from: boundingBox, scaledTo: imageSize)

        let characterObservations = textObservation.characterBoxes?.map {
            CharacterObservation(bounds: CGRect.flippedRect(from: $0.boundingBox, scaledTo: imageSize), textObservationUUID: textObservation.uuid)
        }

        self.characterObservations = characterObservations
    }

    public let bounds: CGRect
    let characterObservations: [CharacterObservation]?
}

public struct WordObservation: TextObservation {
    init(bounds: CGRect, string: String, in image: UIImage) {
        let imageSize = image.size * image.scale
        self.bounds = CGRect.flippedRect(from: bounds, scaledTo: imageSize)
        self.string = string
    }

    public let bounds: CGRect
    public let string: String
}

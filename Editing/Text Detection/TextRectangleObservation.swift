//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Vision

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct TextRectangleObservation: TextObservation {
    #if canImport(UIKit)
    init(_ textObservation: VNTextObservation, in image: UIImage) {
        let imageSize = image.size * image.scale
        self.init(textObservation, scaledTo: imageSize)
    }
    #elseif canImport(AppKit)
    init(_ textObservation: VNTextObservation, in image: NSImage) {
        self.init(textObservation, scaledTo: image.size)
    }
    #endif

    private init(_ textObservation: VNTextObservation, scaledTo imageSize: CGSize) {
        let boundingBox = textObservation.boundingBox
        self.bounds = CGRect.flippedRect(from: boundingBox, scaledTo: imageSize)

        let characterObservations = textObservation.characterBoxes?.map {
            CharacterObservation(bounds: CGRect.flippedRect(from: $0.boundingBox, scaledTo: imageSize), textObservationUUID: textObservation.uuid)
        }

        self.characterObservations = characterObservations
    }

    public let bounds: CGRect
    let characterObservations: [CharacterObservation]?
}

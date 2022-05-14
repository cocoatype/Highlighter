//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Vision

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol TextObservation: Equatable {
    var bounds: CGRect { get }
}

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

public struct WordObservation: TextObservation {
    #if canImport(UIKit)
    init(bounds: CGRect, string: String, in image: UIImage, textObservationUUID: UUID) {
        let imageSize = image.size * image.scale
        self.bounds = CGRect.flippedRect(from: bounds, scaledTo: imageSize)
        self.string = string
        self.textObservationUUID = textObservationUUID
    }
    #elseif canImport(AppKit)
    init(bounds: CGRect, string: String, in image: NSImage, textObservationUUID: UUID) {
        let imageSize = image.size
        self.bounds = CGRect.flippedRect(from: bounds, scaledTo: imageSize)
        self.string = string
        self.textObservationUUID = textObservationUUID
    }
    #endif

    public let bounds: CGRect
    public let string: String
    public let textObservationUUID: UUID
}

extension Array where Element == WordObservation {
    func matching(_ strings: [String]) -> [WordObservation] {
        return filter { observation in
            strings.contains(where: { wordListString in
                wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
            })
        }
    }
}

//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct WordObservation: TextObservation {
    #if canImport(UIKit)
    init(bounds: CGRect, string: String, in image: UIImage, textObservationUUID: UUID) {
        let imageSize = image.size * image.scale
        self.init(bounds: bounds, string: string, imageSize: imageSize, textObservationUUID: textObservationUUID)
    }
    #elseif canImport(AppKit)
    init(bounds: CGRect, string: String, in image: NSImage, textObservationUUID: UUID) {
        self.init(bounds: bounds, string: string, imageSize: image.size, textObservationUUID: textObservationUUID)
    }
    #endif

    init(bounds: CGRect, string: String, imageSize: CGSize, textObservationUUID: UUID) {
        self.bounds = CGRect.flippedRect(from: bounds, scaledTo: imageSize)
        self.string = string
        self.textObservationUUID = textObservationUUID
    }

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

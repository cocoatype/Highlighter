//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct WordObservation: TextObservation {
    #if canImport(UIKit)
    init(bounds: Shape, string: String, in image: UIImage, textObservationUUID: UUID) {
        let imageSize = image.size * image.scale
        self.init(bounds: bounds, string: string, imageSize: imageSize, textObservationUUID: textObservationUUID)
    }
    #elseif canImport(AppKit)
    init(bounds: Shape, string: String, in image: NSImage, textObservationUUID: UUID) {
        self.init(bounds: bounds, string: string, imageSize: image.size, textObservationUUID: textObservationUUID)
    }
    #endif

    init(bounds: Shape, string: String, imageSize: CGSize, textObservationUUID: UUID) {
        self.bounds = bounds.scaled(to: imageSize)
        self.string = string
        self.textObservationUUID = textObservationUUID
    }

    public let bounds: Shape
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

public struct Shape: Equatable {
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
    let topLeft: CGPoint
    let topRight: CGPoint

    internal init(bottomLeft: CGPoint, bottomRight: CGPoint, topLeft: CGPoint, topRight: CGPoint) {
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
        self.topLeft = topLeft
        self.topRight = topRight
    }

    func scaled(to imageSize: CGSize) -> Shape {
        return Shape(
            bottomLeft: CGPoint.flippedPoint(from: bottomLeft, scaledTo: imageSize),
            bottomRight: CGPoint.flippedPoint(from: bottomRight, scaledTo: imageSize),
            topLeft: CGPoint.flippedPoint(from: topLeft, scaledTo: imageSize),
            topRight: CGPoint.flippedPoint(from: topRight, scaledTo: imageSize)
        )
    }

    var boundingBox: CGRect {
        guard let minX = [bottomLeft.x, bottomRight.x, topLeft.x, topRight.x].min(),
              let maxX = [bottomLeft.x, bottomRight.x, topLeft.x, topRight.x].max(),
              let minY = [bottomLeft.y, bottomRight.y, topLeft.y, topRight.y].min(),
              let maxY = [bottomLeft.y, bottomRight.y, topLeft.y, topRight.y].max()
        else { return .zero }

        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    func union(_ other: Shape) -> Shape {
        // TODO: FIX ME!!!
        return self
    }
}

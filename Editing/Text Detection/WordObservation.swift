//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct WordObservation: TextObservation, RedactableObservation {
    init?(recognizedText: RecognizedText, string: String, range: Range<String.Index>, imageSize: CGSize) {
        let visionText = recognizedText.recognizedText
        // shapeThing by @CompileSwift on 11/21/22
        guard let shapeThing = try? visionText.boundingBox(for: range) else { return nil }

        self.bounds = Shape(shapeThing).scaled(to: imageSize)
        self.string = string
        self.textObservationUUID = recognizedText.uuid

        self.characterObservations = visionText
            .string
            .indices
            .compactMap { index -> CharacterObservation? in
                print("evaluating index: \(index.encodedOffset) in substring \"\(string)\" of string \"\(visionText.string)\"")
                guard range.contains(index) else {
                    print("range \(range) did not contain index")
                    return nil
                }
                guard index < string.endIndex else {
                    print("index \(index) was not less than end index \(string.endIndex)")
                    return nil
                }

                let characterRange = Range<String.Index>(uncheckedBounds: (index, string.index(after: index)))
                print("getting bounds for range \(characterRange)")
                guard let characterShapeThing = try? visionText.boundingBox(for: characterRange) else {
                    print("text did not have bounding box for range \(characterRange)")
                    return nil
                }
                let bounds = CGRect.flippedRect(from: characterShapeThing.boundingBox, scaledTo: imageSize)
                return CharacterObservation(bounds: bounds, textObservationUUID: recognizedText.uuid)
            }
    }

    public let bounds: Shape
    public let string: String
    public let textObservationUUID: UUID

    let characterObservations: [CharacterObservation]
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

    var path: CGPath {
        var path = CGMutablePath()
        path.move(to: topLeft)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.addLine(to: topRight)
        path.closeSubpath()
        return path
    }

    func union(_ other: Shape) -> Shape {
        // TODO: FIX ME!!!
        return self
    }
}

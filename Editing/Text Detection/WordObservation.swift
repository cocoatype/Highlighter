//  Created by Geoff Pado on 5/17/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct WordObservation: TextObservation {
    init?(recognizedText: RecognizedText, string: String, range: Range<String.Index>, imageSize: CGSize) {
        let visionText = recognizedText.recognizedText
        // shapeThing by @CompileSwift on 11/21/22
        guard let shapeThing = try? visionText.boundingBox(for: range) else { return nil }

        self.bounds = Shape(shapeThing).scaled(to: imageSize)
        self.string = string
        self.textObservationUUID = recognizedText.uuid
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

public struct Shape: Hashable {
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
        let path = CGMutablePath()
        path.move(to: topLeft)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.addLine(to: topRight)
        path.closeSubpath()
        return path
    }

    var angle: Double {
        let centerLeft = CGPoint(
            x: (topLeft.x + bottomLeft.x) / 2.0,
            y: (topLeft.y + bottomLeft.y) / 2.0
        )
        let centerRight = CGPoint(
            x: (topRight.x + bottomRight.x) / 2.0,
            y: (topRight.y + bottomRight.y) / 2.0
        )

        // leftyLoosey by @KaenAitch on 2/3/22
        // the point that defines the right angle
        let leftyLoosey: CGPoint

        if centerRight.y < centerLeft.y {
            leftyLoosey = CGPoint(x: centerRight.x, y: centerLeft.y)
        } else {
            leftyLoosey = CGPoint(x: centerLeft.x, y: centerRight.y)
        }

        let hypotenuseDistance = centerLeft.distance(to: centerRight)
        let adjacentDistance = leftyLoosey.x - centerLeft.x

        return cos(adjacentDistance / hypotenuseDistance)
    }

    var center: CGPoint {
        CGPoint(
            x: (topLeft.x + bottomLeft.x + bottomRight.x + topRight.x) / 4.0,
            y: (topLeft.y + bottomLeft.y + bottomRight.y + topRight.y) / 4.0
        )
    }

    func simpleUnion(_ other: Shape) -> Shape {
        let coordinates = [bottomLeft, bottomRight, topLeft, topRight, other.bottomLeft, other.bottomRight, other.topLeft, other.topRight]

        let xSort = { (lhs: CGPoint, rhs: CGPoint) -> Bool in lhs.x < rhs.x }
        let ySort = { (lhs: CGPoint, rhs: CGPoint) -> Bool in lhs.y < rhs.y }

        let minX = coordinates.min(by: xSort)!
        let minY = coordinates.min(by: ySort)!
        let maxX = coordinates.max(by: xSort)!
        let maxY = coordinates.max(by: ySort)!

        return Shape(bottomLeft: maxY, bottomRight: maxX, topLeft: minX, topRight: minY)
    }

    func simpleUnionV2(_ other: Shape) -> Shape {
        var transform = CGAffineTransformMakeTranslation(0, 0);
        transform = CGAffineTransformRotate(transform, angle);
        transform = CGAffineTransformTranslate(transform,-0,-0);

        let coordinates = [bottomLeft, bottomRight, topLeft, topRight, other.bottomLeft, other.bottomRight, other.topLeft, other.topRight].map { $0.applying(transform) }

        let xSort = { (lhs: CGPoint, rhs: CGPoint) -> Bool in lhs.x < rhs.x }
        let ySort = { (lhs: CGPoint, rhs: CGPoint) -> Bool in lhs.y < rhs.y }

        let unrotateTransform = CGAffineTransformMakeRotation(-angle)
        let minX = coordinates.min(by: xSort)!.applying(unrotateTransform)
        let minY = coordinates.min(by: ySort)!.applying(unrotateTransform)
        let maxX = coordinates.max(by: xSort)!.applying(unrotateTransform)
        let maxY = coordinates.max(by: ySort)!.applying(unrotateTransform)

        return Shape(bottomLeft: maxY, bottomRight: maxX, topLeft: minX, topRight: minY)
    }

    func slopeUnion(_ other: Shape) -> Shape {
        let horizontallySortedPoints = [bottomLeft, bottomRight, topLeft, topRight, other.bottomLeft, other.bottomRight, other.topLeft, other.topRight].sorted(by: { lhs, rhs in
            lhs.x < rhs.x
        })

        let leftPoints = Array(horizontallySortedPoints.prefix(2))
        let rightPoints = Array(horizontallySortedPoints.suffix(2))

        let dy = (leftPoints[0].y - leftPoints[1].y)
        let dx = (leftPoints[0].x - leftPoints[1].x)

        if dx == 0 {
            let (topLeftPoint, bottomLeftPoint) = (leftPoints[0].y < leftPoints[1].y) ? (leftPoints[0], leftPoints[1]) : (leftPoints[1], leftPoints[0])
            let (topRightPoint, bottomRightPoint) = (rightPoints[0].y < rightPoints[1].y) ? (rightPoints[0], rightPoints[1]) : (rightPoints[1], rightPoints[0])

            return Shape(bottomLeft: bottomLeftPoint, bottomRight: bottomRightPoint, topLeft: topLeftPoint, topRight: topRightPoint)
        }

        let slope = dy / dx

        if slope > 0 {
            return Shape(bottomLeft: leftPoints[1], bottomRight: rightPoints[1], topLeft: leftPoints[0], topRight: rightPoints[0])
        } else {
            return Shape(bottomLeft: leftPoints[0], bottomRight: rightPoints[0], topLeft: leftPoints[1], topRight: rightPoints[1])
        }
    }

    func boundingUnion(_ other: Shape) -> Shape {
        return Shape(
            bottomLeft: CGPoint(
                x: min(bottomLeft.x, other.bottomLeft.x),
                y: max(bottomLeft.y, other.bottomLeft.y)),
            bottomRight: CGPoint(
                x: max(bottomRight.x, other.bottomRight.x),
                y: max(bottomRight.y, other.bottomRight.y)),
            topLeft: CGPoint(
                x: min(topLeft.x, other.topLeft.x),
                y: min(topLeft.y, other.topLeft.y)),
            topRight: CGPoint(
                x: max(topRight.x, other.topRight.x),
                y: min(topRight.y, other.topRight.y)))
    }

    func union(_ other: Shape) -> Shape {
        return simpleUnionV2(other)
    }

    static let zero = Shape(bottomLeft: .zero, bottomRight: .zero, topLeft: .zero, topRight: .zero)
    var isNotZero: Bool {
        self != Self.zero
    }
}

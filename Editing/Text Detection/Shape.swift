//  Created by Geoff Pado on 2/4/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation
import CoreGraphics

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

    var boundingBox: CGRect { path.boundingBox }

    var path: CGPath {
        let path = CGMutablePath()
        path.move(to: topLeft)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.addLine(to: topRight)
        path.closeSubpath()
        return path
    }

    var centerLeft: CGPoint {
        CGPoint(
            x: (topLeft.x + bottomLeft.x) / 2.0,
            y: (topLeft.y + bottomLeft.y) / 2.0
        )
    }

    var centerRight: CGPoint {
        CGPoint(
            x: (topRight.x + bottomRight.x) / 2.0,
            y: (topRight.y + bottomRight.y) / 2.0
        )
    }

    var angle: Double {
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

    func union(_ other: Shape) -> Shape {
        let transform = CGAffineTransformMakeRotation(angle);

        let ourRotatedCenterLeft = centerLeft.applying(transform)
        let otherRotatedCenterLeft = other.centerLeft.applying(transform)
        let ourRotatedCenterRight = centerRight.applying(transform)
        let otherRotatedCenterRight = other.centerRight.applying(transform)

        // rightyTighty by @KaenAitch on 2/3/22
        // the left-most shape
        let rightyTighty: Shape
        if ourRotatedCenterLeft.x < otherRotatedCenterLeft.x {
            rightyTighty = self
        } else {
            rightyTighty = other
        }

        let rightMostShape: Shape
        if ourRotatedCenterRight.x > otherRotatedCenterRight.x {
            rightMostShape = self
        } else {
            rightMostShape = other
        }

        return Shape(bottomLeft: rightyTighty.bottomLeft, bottomRight: rightMostShape.bottomRight, topLeft: rightyTighty.topLeft, topRight: rightMostShape.topRight)
    }

    static let zero = Shape(bottomLeft: .zero, bottomRight: .zero, topLeft: .zero, topRight: .zero)
    var isNotZero: Bool {
        self != Self.zero
    }
}

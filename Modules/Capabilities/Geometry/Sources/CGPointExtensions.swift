//  Created by Geoff Pado on 5/20/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import CoreGraphics

public extension CGPoint {
    static func * (point: CGPoint, multiplier: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * multiplier, y: point.y * multiplier)
    }

    static func + (point: CGPoint, size: CGSize) -> CGPoint {
        return CGPoint(x: point.x + size.width, y: point.y + size.height)
    }

    func distance(to otherPoint: CGPoint) -> Double {
        func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
            return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
        }

        func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
            return sqrt(CGPointDistanceSquared(from: from, to: to))
        }

        return CGPointDistance(from: self, to: otherPoint)
    }

    static func flippedPoint(from point: CGPoint, scaledTo size: CGSize) -> CGPoint {
        var scaledPoint = point

        #if canImport(UIKit)
        scaledPoint.y = (1.0 - scaledPoint.y)
        #endif

        scaledPoint.x *= size.width
        scaledPoint.y *= size.height

        return scaledPoint
    }

    func isEqual(to otherPoint: CGPoint, accuracy: Double) -> Bool {
        return (abs(x - otherPoint.x) < accuracy) && (abs(y - otherPoint.y) < accuracy)
    }
}

extension CGPoint: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

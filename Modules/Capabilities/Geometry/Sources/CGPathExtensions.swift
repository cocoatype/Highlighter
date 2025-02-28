//  Created by Geoff Pado on 5/20/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import CoreGraphics

extension CGPathElementType {
    var pointCount: Int {
        switch self {
        case .closeSubpath: 0
        case .moveToPoint, .addLineToPoint: 1
        case .addQuadCurveToPoint: 2
        case .addCurveToPoint: 3
        @unknown default: 0
        }
    }
}

public extension CGPath {
    func isEqual(to otherPath: CGPath, accuracy: Double) -> Bool {
        var ourPathElements = [PathElement]()
        applyWithBlock { elementPointer in
            ourPathElements.append(PathElement(elementPointer: elementPointer))
        }

        var otherPathElements = [PathElement]()
        otherPath.applyWithBlock { elementPointer in
            otherPathElements.append(PathElement(elementPointer: elementPointer))
        }

        return ourPathElements.elementsEqual(otherPathElements) { ourElement, otherElement in
            guard ourElement.type == otherElement.type else { return false }

            switch ourElement.type {
            case .moveToPoint:
                return ourElement.points[0].isEqual(to: otherElement.points[0], accuracy: accuracy)
            case .addLineToPoint:
                return ourElement.points[0].isEqual(to: otherElement.points[0], accuracy: accuracy)
            case .addQuadCurveToPoint:
                return ourElement.points[0].isEqual(to: otherElement.points[0], accuracy: accuracy)
                && ourElement.points[1].isEqual(to: otherElement.points[1], accuracy: accuracy)
            case .addCurveToPoint:
                return ourElement.points[0].isEqual(to: otherElement.points[0], accuracy: accuracy)
                && ourElement.points[1].isEqual(to: otherElement.points[1], accuracy: accuracy)
                && ourElement.points[2].isEqual(to: otherElement.points[2], accuracy: accuracy)
            case .closeSubpath:
                return true
            @unknown default:
                return true
            }
        }
    }

    func forEachPoint(_ function: @escaping ((CGPoint) -> Void)) {
        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            let elementType = element.type
            guard elementType == .moveToPoint || elementType == .addLineToPoint else { return }

            let elementPoint = element.points.pointee
            function(elementPoint)
        }
    }

    func area() -> CGFloat {
        var area: CGFloat = 0.0
        var firstPoint: CGPoint?
        var previousPoint: CGPoint?

        self.applyWithBlock { element in
            let points = element.pointee.points
            switch element.pointee.type {
            case .moveToPoint:
                firstPoint = points[0]
                previousPoint = points[0]
            case .addLineToPoint:
                if let previous = previousPoint {
                    area += (previous.x * points[0].y) - (points[0].x * previous.y)
                }
                previousPoint = points[0]
            case .closeSubpath:
                if let first = firstPoint, let previous = previousPoint {
                    area += (previous.x * first.y) - (first.x * previous.y)
                }
                previousPoint = firstPoint
            default:
                break
            }
        }

        return abs(area) / 2.0
    }
}

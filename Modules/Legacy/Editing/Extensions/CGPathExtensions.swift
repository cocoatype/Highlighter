//  Created by Geoff Pado on 2/3/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation
import CoreGraphics

extension CGPath {
    func forEachPoint(_ function: @escaping ((CGPoint) -> Void)) {
        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            let elementType = element.type
            guard elementType == .moveToPoint || elementType == .addLineToPoint else { return }

            let elementPoint = element.points.pointee
            function(elementPoint)
        }
    }

    func isEqual(to otherPath: CGPath, accuracy: Double) -> Bool {
        var ourPathElements = [CGPathElement]()
        applyWithBlock { elementPointer in
            ourPathElements.append(elementPointer.pointee)
        }

        var otherPathElements = [CGPathElement]()
        otherPath.applyWithBlock { elementPointer in
            otherPathElements.append(elementPointer.pointee)
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

    func svg(color: String) -> String {
        var string = ""
        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            let elementType = element.type
            switch elementType {
            case .moveToPoint:
                string.append("M ")
                let elementPoint = element.points.pointee
                string.append("\(elementPoint.x),\(elementPoint.y)")
                string.append("\n")
            case .addLineToPoint:
                string.append("L ")
                let elementPoint = element.points.pointee
                string.append("\(elementPoint.x),\(elementPoint.y)")
                string.append("\n")
            case .addCurveToPoint:
                string.append("C ")
                string.append("\n")
                // TODO: Implement me!
            case .addQuadCurveToPoint:
                string.append("Q ")
                string.append("\n")
                // TODO: Implement me!
            case .closeSubpath:
                string.append("Z\n")
            @unknown default: break
            }
        }
        return "<path d=\"\(string)\" fill=\"\(color)\" fill-opacity=\"0.3\"/>"
    }
}

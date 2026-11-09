//  Created by Geoff Pado on 5/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import Geometry
import UIKit

extension UIBezierPath {
    var shape: Geometry.Shape? {
        var points = [CGPoint]()
        cgPath.applyWithBlock { element in
            switch element.pointee.type {
            case .moveToPoint, .addLineToPoint:
                points.append(element.pointee.points[0])
            case .addQuadCurveToPoint, .addCurveToPoint, .closeSubpath:
                break
            @unknown default:
                break
            }
        }

        return Shape(
            bottomLeft: points[1],
            bottomRight: points[2],
            topLeft: points[0],
            topRight: points[3]
        )
    }
}
#endif

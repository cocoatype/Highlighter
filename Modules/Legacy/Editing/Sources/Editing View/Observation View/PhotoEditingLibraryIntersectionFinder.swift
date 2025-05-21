//  Created by Geoff Pado on 6/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

private import ClippingBezier
import CoreGraphics
import Observations

struct PhotoEditingLibraryIntersectionFinder: PhotoEditingIntersectionFinder {
    func intersectionExists(between lhs: CGPath, and rhs: CGPath) -> Bool {
        let lhsPath = UIBezierPath(cgPath: lhs)
        let rhsPath = UIBezierPath(cgPath: rhs)

        let intersections = lhsPath.intersection(with: rhsPath)
        guard intersections?.count ?? 0 == 0 else { return true }

        let inverseIntersections = rhsPath.intersection(with: lhsPath)
        guard inverseIntersections?.count ?? 0 == 0 else { return true }

        return false
    }
}

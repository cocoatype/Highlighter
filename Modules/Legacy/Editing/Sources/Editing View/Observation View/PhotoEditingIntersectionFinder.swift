//  Created by Geoff Pado on 6/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Observations

protocol PhotoEditingIntersectionFinder {
    func intersectionExists(between lhs: CGPath, and rhs: CGPath) -> Bool
}

//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import GeometryMac
#elseif canImport(UIKit)
import Geometry
#endif

import CoreGraphics

extension Shape {
    static let sample = Shape(
        bottomLeft: CGPoint(x: 0, y: 5),
        bottomRight: CGPoint(x: 5, y: 5),
        topLeft: CGPoint(x: 0, y: 0),
        topRight: CGPoint(x: 5, y: 0)
    )
}

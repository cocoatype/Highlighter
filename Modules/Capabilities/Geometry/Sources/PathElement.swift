//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics

struct PathElement {
    let points: [CGPoint]
    let type: CGPathElementType

    init(elementPointer: UnsafePointer<CGPathElement>) {
        let element = elementPointer.pointee
        type = element.type
        points = Array(UnsafeBufferPointer(start: element.points, count: type.pointCount))
    }
}

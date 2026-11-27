//  Created by Geoff Pado on 5/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Geometry

#if canImport(UIKit)
import UIKit
#endif

public enum RedactionPart: Equatable, Sendable {
    case path(RedactionPath)
    case shape(Shape)

    #if canImport(UIKit)
    /// A new `UIBezierPath` for this part. Each call returns a separate instance.
    var bezierPath: UIBezierPath {
        switch self {
        case .path(let path): return path.bezierPath
        case .shape(let shape): return UIBezierPath(cgPath: shape.path)
        }
    }
    #endif
}

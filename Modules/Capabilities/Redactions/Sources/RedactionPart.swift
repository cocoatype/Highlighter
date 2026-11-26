//  Created by Geoff Pado on 5/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Geometry
import UIKit

public enum RedactionPart: Equatable, Sendable {
    case path(RedactionPath)
    case shape(Shape)

    /// A new `UIBezierPath` for this part. Each call returns a separate instance.
    var bezierPath: UIBezierPath {
        switch self {
        case .path(let path): return path.bezierPath
        case .shape(let shape): return UIBezierPath(cgPath: shape.path)
        }
    }
}

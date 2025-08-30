//  Created by Geoff Pado on 5/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Geometry
import UIKit

public enum RedactionPart: Equatable {
    case path(UIBezierPath)
    case shape(Shape)

    var path: UIBezierPath {
        switch self {
        case .path(let path): return path
        case .shape(let shape): return UIBezierPath(cgPath: shape.path)
        }
    }
}

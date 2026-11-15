//  Created by Geoff Pado on 5/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Geometry
import UIKit

// UIBezierPath isn't Sendable. This is only safe because Redaction copies paths when it's created, and nothing
// mutates a path after it's part of a redaction. Remove when RedactionPart stores a Sendable path type (#479).
public enum RedactionPart: Equatable, @unchecked Sendable {
    case path(UIBezierPath)
    case shape(Shape)

    var path: UIBezierPath {
        switch self {
        case .path(let path): return path
        case .shape(let shape): return UIBezierPath(cgPath: shape.path)
        }
    }
}

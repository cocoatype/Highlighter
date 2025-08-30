//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public struct Redaction: Equatable {
    public let color: UIColor
    public let parts: [RedactionPart]

    public init(color: UIColor, parts: [RedactionPart]) {
        self.color = color
        self.parts = parts.filter { part in
            if case .shape(let shape) = part {
                return shape.isNotEmpty
            } else { return true }
        }
    }

    public var paths: [UIBezierPath] {
        parts.map(\.path)
    }
}

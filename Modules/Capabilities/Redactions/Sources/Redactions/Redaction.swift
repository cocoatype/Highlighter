//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public struct Redaction: Equatable, Sendable {
    public let color: UIColor
    public let parts: [RedactionPart]

    public init(color: UIColor, parts: [RedactionPart]) {
        self.color = color
        self.parts = parts.filter { part in
            switch part {
            case .shape(let shape): shape.isNotEmpty
            case .path: true
            }
        }
    }

    /// New `UIBezierPath`s for this redaction's parts. Each call returns separate instances.
    public var paths: [UIBezierPath] {
        parts.map(\.bezierPath)
    }
}

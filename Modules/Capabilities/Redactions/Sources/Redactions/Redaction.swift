//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public struct Redaction: Equatable, Sendable {
    public let color: UIColor
    public let parts: [RedactionPart]

    public init(color: UIColor, parts: [RedactionPart]) {
        self.color = color
        self.parts = parts.compactMap { part in
            switch part {
            case .shape(let shape):
                return shape.isNotEmpty ? part : nil
            case .path(let path):
                // copy so the caller can't mutate a path that's been shared across threads; see RedactionPart
                // swiftlint:disable:next force_cast
                return .path(path.copy() as! UIBezierPath)
            }
        }
    }

    public var paths: [UIBezierPath] {
        parts.map(\.path)
    }
}

//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import DesignSystem

public struct Redaction: Equatable, Sendable {
    private let rgb: RGB
    public let parts: [RedactionPart]

    public init(color: UIColor, parts: [RedactionPart]) {
        self.rgb = RGB(color: color)
        self.parts = parts.filter { part in
            switch part {
            case .shape(let shape): shape.isNotEmpty
            case .path: true
            }
        }
    }

    #if canImport(UIKit)
    public var color: UIColor { UIColor(rgb) }

    /// New `UIBezierPath`s for this redaction's parts. Each call returns separate instances.
    public var paths: [UIBezierPath] {
        parts.map(\.bezierPath)
    }
    #elseif canImport(AppKit)
    #endif
}

//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public typealias RedactionColor = NSColor
public typealias RedactionPath = NSBezierPath
#elseif canImport(UIKit)
import UIKit

public typealias RedactionColor = UIColor
public typealias RedactionPath = UIBezierPath

#endif

public enum RedactionPart: Equatable {
    case path(RedactionPath)
    case shape(Shape)

    var path: RedactionPath {
        switch self {
        case .path(let path): return path
        case .shape(let shape): return RedactionPath(cgPath: shape.path)
        }
    }
}

public struct Redaction: Equatable {
    public let color: RedactionColor
    public let parts: [RedactionPart]

    init(color: RedactionColor, parts: [RedactionPart]) {
        self.color = color
        self.parts = parts.filter { part in
            if case .shape(let shape) = part {
                return shape.isNotEmpty
            } else { return true }
        }
    }

    public var paths: [RedactionPath] {
        parts.map(\.path)
    }
}

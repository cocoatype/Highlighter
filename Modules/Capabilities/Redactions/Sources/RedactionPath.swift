//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

/// An immutable brush stroke: the stroke's geometry plus the `UIBezierPath` drawing properties that the
/// renderer, the editing view, and the saved format depend on.
///
/// The geometry is stored as path elements rather than a `CGPath`, because `CGPath` isn't `Sendable`.
public struct RedactionPath: Equatable, Sendable {
    public enum Element: Equatable, Sendable {
        case move(to: CGPoint)
        case line(to: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case closeSubpath
    }

    public let elements: [Element]
    public let lineWidth: CGFloat
    public let lineCapStyle: CGLineCap
    public let lineJoinStyle: CGLineJoin
    public let miterLimit: CGFloat
    public let flatness: CGFloat
    public let usesEvenOddFillRule: Bool

    init(
        elements: [Element],
        lineWidth: CGFloat,
        lineCapStyle: CGLineCap,
        lineJoinStyle: CGLineJoin,
        miterLimit: CGFloat,
        flatness: CGFloat,
        usesEvenOddFillRule: Bool,
    ) {
        self.elements = elements
        self.lineWidth = lineWidth
        self.lineCapStyle = lineCapStyle
        self.lineJoinStyle = lineJoinStyle
        self.miterLimit = miterLimit
        self.flatness = flatness
        self.usesEvenOddFillRule = usesEvenOddFillRule
    }

    /// A new `CGPath` with this path's geometry.
    public var cgPath: CGPath {
        let path = CGMutablePath()
        for element in elements {
            switch element {
            case .move(let point):
                path.move(to: point)
            case .line(let point):
                path.addLine(to: point)
            case .quadCurve(let point, let control):
                path.addQuadCurve(to: point, control: control)
            case .curve(let point, let control1, let control2):
                path.addCurve(to: point, control1: control1, control2: control2)
            case .closeSubpath:
                path.closeSubpath()
            }
        }
        return path
    }

    public var currentPoint: CGPoint { cgPath.currentPoint }

    // MARK: - UIBezierPath Support

    #if canImport(UIKit)
    public init(_ bezierPath: UIBezierPath) {
        var elements = [Element]()
        bezierPath.cgPath.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint:
                elements.append(.move(to: element.points[0]))
            case .addLineToPoint:
                elements.append(.line(to: element.points[0]))
            case .addQuadCurveToPoint:
                elements.append(.quadCurve(to: element.points[1], control: element.points[0]))
            case .addCurveToPoint:
                elements.append(.curve(to: element.points[2], control1: element.points[0], control2: element.points[1]))
            case .closeSubpath:
                elements.append(.closeSubpath)
            @unknown default:
                break
            }
        }

        self.init(
            elements: elements,
            lineWidth: bezierPath.lineWidth,
            lineCapStyle: bezierPath.lineCapStyle,
            lineJoinStyle: bezierPath.lineJoinStyle,
            miterLimit: bezierPath.miterLimit,
            flatness: bezierPath.flatness,
            usesEvenOddFillRule: bezierPath.usesEvenOddFillRule,
        )
    }

    /// A new `UIBezierPath` with this path's geometry and drawing properties. Each call returns a separate
    /// instance, so callers can mutate the result freely.
    public var bezierPath: UIBezierPath {
        let bezierPath = UIBezierPath(cgPath: cgPath)
        bezierPath.lineWidth = lineWidth
        bezierPath.lineCapStyle = lineCapStyle
        bezierPath.lineJoinStyle = lineJoinStyle
        bezierPath.miterLimit = miterLimit
        bezierPath.flatness = flatness
        bezierPath.usesEvenOddFillRule = usesEvenOddFillRule
        return bezierPath
    }
    #endif
}

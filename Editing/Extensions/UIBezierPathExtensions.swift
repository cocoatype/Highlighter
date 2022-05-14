//  Created by Geoff Pado on 5/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSBezierPath {
    public var dashedPath: NSBezierPath {
        let cgPath = self.cgPath
        let dashedCGPath = cgPath.copy(dashingWithPhase: 0, lengths: [4, 4])
        let dashedPath = NSBezierPath(cgPath: dashedCGPath)
        dashedPath.lineWidth = lineWidth
        return dashedPath
    }

    public func forEachPoint(_ function: @escaping ((CGPoint) -> Void)) {
        cgPath.forEachPoint(function)
    }

    convenience init(cgPath: CGPath) {
        self.init()

        cgPath.applyWithBlock { elementPointer in
            let element = elementPointer.pointee

            switch element.type {
            case .moveToPoint:
                let point = element.points.pointee
                self.move(to: point)
            case .addLineToPoint:
                let point = element.points.pointee
                self.line(to: point)
            case .addQuadCurveToPoint:
                break // NSBezierPath does not support
            case .addCurveToPoint:
                let bufferPointer = UnsafeBufferPointer(start: element.points, count: 3)
                let points = Array(bufferPointer)
                self.curve(to: points[0], controlPoint1: points[1], controlPoint2: points[2])
            case .closeSubpath:
                self.close()
            @unknown default:
                break
            }
        }
    }

    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }

        return path
    }
}
#elseif canImport(UIKit)
import UIKit

extension UIBezierPath {
    var strokeBorderPath: UIBezierPath {
        let cgPath = self.cgPath
        let strokedCGPath = cgPath.copy(strokingWithWidth: lineWidth, lineCap: lineCapStyle, lineJoin: lineJoinStyle, miterLimit: miterLimit)
        return UIBezierPath(cgPath: strokedCGPath)
    }

    public var dashedPath: UIBezierPath {
        let cgPath = self.cgPath
        let dashedCGPath = cgPath.copy(dashingWithPhase: 0, lengths: [4, 4])
        let dashedPath = UIBezierPath(cgPath: dashedCGPath)
        dashedPath.lineWidth = lineWidth
        return dashedPath
    }

    public func forEachPoint(_ function: @escaping ((CGPoint) -> Void)) {
        cgPath.forEachPoint(function)
    }
}
#endif

extension CGPath {
    func forEachPoint(_ function: @escaping ((CGPoint) -> Void)) {
        withUnsafePointer(to: function) { functionPointer in
            let rawFunctionPointer = UnsafeMutableRawPointer(mutating: functionPointer)
            apply(info: rawFunctionPointer) { functionPointer, elementPointer in
                let function = functionPointer?.assumingMemoryBound(to: ((CGPoint) -> Void).self).pointee
                let element = elementPointer.pointee
                let elementType = element.type
                guard elementType == .moveToPoint || elementType == .addLineToPoint else { return }

                let elementPoint = element.points.pointee
                function?(elementPoint)
            }
        }
    }
}

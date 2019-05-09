//  Created by Geoff Pado on 5/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

extension UIBezierPath {
    var strokeBorderPath: UIBezierPath {
        let cgPath = self.cgPath
        let strokedCGPath = cgPath.copy(strokingWithWidth: lineWidth, lineCap: lineCapStyle, lineJoin: lineJoinStyle, miterLimit: miterLimit)
        return UIBezierPath(cgPath: strokedCGPath)
    }

    var dashedPath: UIBezierPath {
        let cgPath = self.cgPath
        let dashedCGPath = cgPath.copy(dashingWithPhase: 0, lengths: [4, 4])
        let dashedPath = UIBezierPath(cgPath: dashedCGPath)
        dashedPath.lineWidth = lineWidth
        return dashedPath
    }

    func forEachPoint(_ function: @escaping ((CGPoint) -> Void)) {
        let cgPath = self.cgPath

        withUnsafePointer(to: function) { functionPointer in
            let rawFunctionPointer = UnsafeMutableRawPointer(mutating: functionPointer)
            cgPath.apply(info: rawFunctionPointer) { functionPointer, elementPointer in
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

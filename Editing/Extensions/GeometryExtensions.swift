//  Created by Geoff Pado on 4/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension CGSize {
    static func * (size: CGSize, multiplier: CGFloat) -> CGSize {
        return CGSize(width: size.width * multiplier, height: size.height * multiplier)
    }
}

public extension CGPoint {
    static func * (point: CGPoint, multiplier: CGFloat) -> CGPoint {
        return CGPoint(x:point.x * multiplier, y: point.y * multiplier)
    }

    static func flippedPoint(from point: CGPoint, scaledTo size: CGSize) -> CGPoint {
        var scaledPoint = point

        #if canImport(UIKit)
        scaledPoint.y = (1.0 - scaledPoint.y)
        #endif

        scaledPoint.x *= size.width
        scaledPoint.y *= size.height

        return scaledPoint
    }

    func isEqual(to otherPoint: CGPoint, accuracy: Double) -> Bool {
        return (abs(x - otherPoint.x) < accuracy) && (abs(y - otherPoint.y) < accuracy)
    }
}

public extension CGRect {
    static func * (rect: CGRect, multiplier: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x * multiplier, y: rect.origin.y * multiplier, width: rect.size.width * multiplier, height: rect.size.height * multiplier)
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    func fitting(rect fittingRect: CGRect) -> CGRect {
        let aspectRatio = width / height
        let fittingAspectRatio = fittingRect.width / fittingRect.height

        if fittingAspectRatio > aspectRatio { //wider fitting rect
            let newRectWidth = aspectRatio * fittingRect.height
            let newRectHeight = fittingRect.height
            let newRectX = (fittingRect.width - newRectWidth) / 2
            let newRectY = CGFloat(0)

            return CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)
        } else if fittingAspectRatio < aspectRatio { //taller fitting rect
            let newRectWidth = fittingRect.width
            let newRectHeight = 1 / (aspectRatio / fittingRect.width)
            let newRectX = CGFloat(0)
            let newRectY = (fittingRect.height - newRectHeight) / 2

            return CGRect(x: newRectX, y: newRectY, width: newRectWidth, height: newRectHeight)

        } else { //same aspect ratio
            return fittingRect
        }
    }

    static func flippedRect(from rect: CGRect, scaledTo size: CGSize) -> CGRect {
        var scaledRect = rect

        #if canImport(UIKit)
        scaledRect.origin.y = (1.0 - scaledRect.origin.y)
        #endif

        scaledRect.origin.x *= size.width
        scaledRect.origin.y *= size.height
        scaledRect.size.width *= size.width
        scaledRect.size.height *= size.height

        #if canImport(UIKit)
        scaledRect.origin.y -= scaledRect.size.height
        #endif

        return scaledRect.integral
    }
}

//  Created by Geoff Pado on 4/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

extension CGSize {
    static func * (size: CGSize, multiplier: CGFloat) -> CGSize {
        return CGSize(width: size.width * multiplier, height: size.height * multiplier)
    }
}

extension CGRect {
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
}

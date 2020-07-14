//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class BrushStampFactory: NSObject {
    static func brushStamp(scaledToHeight height: CGFloat, color: UIColor) -> UIImage {
        guard let standardImage = UIImage(named: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        UIGraphicsBeginImageContext(scaledBrushSize)
        defer { UIGraphicsEndImageContext() }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: scaledBrushSize))

        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to create brush scaling image context") }
        context.scaleBy(x: brushScale, y: brushScale)

        standardImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Unable to get scaled brush image from context") }
        return scaledImage
    }
}

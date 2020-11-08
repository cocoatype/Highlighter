//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

public class BrushStampFactory: NSObject {
    public static func brushStamp(scaledToHeight height: CGFloat, color: UIColor) -> UIImage {
        guard let standardImage = UIImage(named: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        return UIGraphicsImageRenderer(size: scaledBrushSize).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: scaledBrushSize))

            let cgContext = context.cgContext
            cgContext.scaleBy(x: brushScale, y: brushScale)

            standardImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }
    }
}

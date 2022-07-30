//  Created by Geoff Pado on 7/8/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

public class BrushStampFactory: NSObject {
    public static func brushStart(scaledToHeight height: CGFloat, color: UIColor) -> UIImage {
        guard let startImage = UIImage(named: "Brush Start") else { ErrorHandling.crash("Unable to load brush start image") }

        let brushScale = height / startImage.size.height
        let scaledBrushSize = startImage.size * brushScale

        return UIGraphicsImageRenderer(size: scaledBrushSize).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: scaledBrushSize))

            let cgContext = context.cgContext
            cgContext.scaleBy(x: brushScale, y: brushScale)

            startImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }
    }

    public static func brushEnd(scaledToHeight height: CGFloat, color: UIColor) -> UIImage {
        guard let endImage = UIImage(named: "Brush End") else { ErrorHandling.crash("Unable to load brush end image") }

        let brushScale = height / endImage.size.height
        let scaledBrushSize = endImage.size * brushScale

        return UIGraphicsImageRenderer(size: scaledBrushSize).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: scaledBrushSize))

            let cgContext = context.cgContext
            cgContext.scaleBy(x: brushScale, y: brushScale)

            endImage.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }
    }
}

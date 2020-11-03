//  Created by Geoff Pado on 10/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import os.log
import Redacting

class BrushStampFactory: NSObject {
    static func brushStamp(scaledToHeight height: CGFloat, color: NSColor) -> NSImage {
        guard let standardImage = Bundle(for: Self.self).image(forResource: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        return NSImage(size: scaledBrushSize, flipped: false) { drawRect -> Bool in
            color.setFill()

            CGRect(origin: .zero, size: scaledBrushSize).fill()

            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            context.scaleBy(x: brushScale, y: brushScale)

            standardImage.draw(at: .zero, from: CGRect(origin: .zero, size: standardImage.size), operation: .destinationIn, fraction: 1)

            return true
        }
    }
}

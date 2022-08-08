//  Created by Geoff Pado on 10/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import os.log
import Redacting

class BrushStampFactory: NSObject {
    static func brushStart(scaledToHeight height: CGFloat, color: NSColor) -> NSImage {
        guard let standardImage = Bundle(for: Self.self).image(forResource: "Brush Start") else { fatalError("Unable to load brush start image") }
        return scaledImage(from: standardImage, toHeight: height, color: color)
    }

    static func brushEnd(scaledToHeight height: CGFloat, color: NSColor) -> NSImage {
        guard let standardImage = Bundle(for: Self.self).image(forResource: "Brush End") else { fatalError("Unable to load brush end image") }
        return scaledImage(from: standardImage, toHeight: height, color: color)
    }

    private static func scaledImage(from image: NSImage, toHeight height: CGFloat, color: NSColor) -> NSImage {
        let brushScale = height / image.size.height
        let scaledBrushSize = image.size * brushScale

        return NSImage(size: scaledBrushSize, flipped: false) { drawRect -> Bool in
            color.setFill()

            CGRect(origin: .zero, size: scaledBrushSize).fill()

            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            context.scaleBy(x: brushScale, y: brushScale)

            image.draw(at: .zero, from: CGRect(origin: .zero, size: image.size), operation: .destinationIn, fraction: 1)

            return true
        }
    }
}

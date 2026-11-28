//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A brush image from an asset catalog, used as an alpha mask when tinting brush images.
struct BrushMask {
    let image: CGImage

    /// The image's size in points.
    let size: CGSize

    init?(named name: String, in bundle: Bundle) {
        #if canImport(UIKit)
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil),
              let cgImage = image.cgImage
        else { return nil }

        self.image = cgImage
        self.size = image.size
        #elseif canImport(AppKit)
        guard let image = bundle.image(forResource: name) else { return nil }

        var proposedRect = CGRect(origin: .zero, size: image.size)
        guard let cgImage = image.cgImage(forProposedRect: &proposedRect, context: nil, hints: nil)
        else { return nil }

        self.image = cgImage
        self.size = image.size
        #endif
    }

    /// The scale to render at when the caller doesn't give one: the main screen's scale.
    static var defaultScale: CGFloat {
        #if canImport(UIKit)
        UIGraphicsImageRendererFormat.default().scale
        #elseif canImport(AppKit)
        NSScreen.main?.backingScaleFactor ?? 1
        #endif
    }
}

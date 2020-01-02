//  Created by Geoff Pado on 1/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class RedactionPathLayer: CALayer {
    init(path: UIBezierPath, brushWidth: CGFloat) {
        let pathBounds = path.strokeBorderPath.bounds.insetBy(dx: -brushWidth, dy: 0)
        path.apply(CGAffineTransform(translationX: -pathBounds.origin.x, y: -pathBounds.origin.y))

        self.path = path
        self.brushWidth = brushWidth
        super.init()

        frame = pathBounds
        masksToBounds = false

        setNeedsDisplay()
    }

    override init(layer: Any) {
        let pathLayer = layer as? RedactionPathLayer
        self.brushWidth = pathLayer?.brushWidth ?? 0
        self.path = pathLayer?.path ?? UIBezierPath()
        super.init(layer: layer)
    }

    override func draw(in context: CGContext) {
        guard let brushStampImage = brushStamp(scaledToHeight: brushWidth).cgImage else { fatalError("Unable to create brush stamp image") }
        path.forEachPoint { point in
            let imageSize = CGSize(width: brushStampImage.width, height: brushStampImage.height)
            let drawRect = CGRect(origin: point, size: imageSize).offsetBy(dx: imageSize.width * -0.5, dy: imageSize.height * -0.5)
            context.draw(brushStampImage, in: drawRect)
        }
    }

    private func brushStamp(scaledToHeight height: CGFloat) -> UIImage {
        guard let standardImage = UIImage(named: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        UIGraphicsBeginImageContext(scaledBrushSize)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to create brush scaling image context") }
        context.scaleBy(x: brushScale, y: brushScale)

        standardImage.draw(at: .zero)

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Unable to get scaled brush image from context") }
        return scaledImage
    }

    // MARK: Boilerplate

    private let brushWidth: CGFloat
    private let path: UIBezierPath

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

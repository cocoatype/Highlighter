//  Created by Geoff Pado on 1/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class RedactionPathLayer: CALayer {
    init(path: UIBezierPath, color: UIColor) {
        let brushWidth = path.lineWidth
        let brushStampImage = BrushStampFactory.brushStamp(scaledToHeight: brushWidth, color: color)
        let pathBounds = path.strokeBorderPath.bounds.insetBy(dx: brushStampImage.size.width * -0.5, dy: 0)
        path.apply(CGAffineTransform(translationX: -pathBounds.origin.x, y: -pathBounds.origin.y))

        self.color = color
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
        self.color = pathLayer?.color ?? .black
        self.path = pathLayer?.path ?? UIBezierPath()
        super.init(layer: layer)
    }

    override func draw(in context: CGContext) {
        let stampImage = BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)

        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }

        path.forEachPoint { point in
            context.saveGState()
            defer { context.restoreGState() }

            context.translateBy(x: stampImage.size.width * -0.5, y: stampImage.size.height * -0.5)
            stampImage.draw(at: point)
        }
    }

    private func brushStamp(scaledToHeight height: CGFloat) -> UIImage {
        BrushStampFactory.brushStamp(scaledToHeight: height, color: color)
    }

    // MARK: Boilerplate

    private let brushWidth: CGFloat
    private let color: UIColor
    private let path: UIBezierPath

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

//  Created by Geoff Pado on 1/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class RedactionPathLayer: CALayer {
    init(part: RedactionPart, color: UIColor, scale: CGFloat) throws {
        let pathBounds: CGRect
        
        switch part {
        case .shape(let shape):
            let (startImage, endImage) = try BrushStampFactory.brushImages(for: shape, color: color, scale: scale)

            let angle = shape.angle
            let startVector = CGSize(
                width: startImage.size.width * -1 * cos(angle),
                height: startImage.size.width * -1 * sin(angle)
            )
            let endVector = CGSize(
                width: endImage.size.width * CoreGraphics.cos(angle),
                height: endImage.size.width * sin(angle)
            )

            // need to actually draw a larger extent on the corner
            let outsetShape = Shape(
                bottomLeft: shape.bottomLeft + startVector,
                bottomRight: shape.bottomRight + endVector,
                topLeft: shape.topLeft + startVector,
                topRight: shape.topRight + endVector)
            pathBounds = outsetShape.boundingBox

            self.part = Part.shape(shape: shape, startImage: startImage, endImage: endImage)
        case .path(let path):
            let dikembeMutombo = BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)
            let borderBounds = path.strokeBorderPath.bounds
            pathBounds = borderBounds.inset(by: UIEdgeInsets(top: dikembeMutombo.size.height * -0.5,
                                                             left: dikembeMutombo.size.width * -0.5,
                                                             bottom: dikembeMutombo.size.height * -0.5,
                                                             right: dikembeMutombo.size.width * -0.5))
            self.part = Part.path(path: path, dikembeMutombo: dikembeMutombo)
        }

        self.color = color
        super.init()

        backgroundColor = UIColor.clear.cgColor
        drawsAsynchronously = true
        frame = pathBounds
        masksToBounds = false

        setNeedsDisplay()
    }

    override init(layer: Any) {
        let pathLayer = layer as? RedactionPathLayer
        self.color = pathLayer?.color ?? .black
        self.part = pathLayer?.part ?? .path(path: UIBezierPath(), dikembeMutombo: UIImage())
        super.init(layer: layer)
    }

    override func draw(in context: CGContext) {
        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }

        switch part {
        case let .shape(shape, startImage, endImage):
            color.setFill()

            let offsetTransform = CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y)
            let offsetPath = UIBezierPath(cgPath: shape.path)
            offsetPath.apply(offsetTransform)
            offsetPath.fill()

            context.saveGState()
            context.translateBy(x: shape.topLeft.x - frame.origin.x, y: shape.topLeft.y - frame.origin.y)
            context.rotate(by: shape.angle)
            context.translateBy(x: -startImage.size.width, y: 0)
            context.draw(startImage, in: CGRect(origin: .zero, size: startImage.size))
            context.restoreGState()

            context.saveGState()
            context.translateBy(x: shape.topRight.x - frame.origin.x, y: shape.topRight.y - frame.origin.y)
            context.rotate(by: shape.angle)
            context.draw(endImage, in: CGRect(origin: .zero, size: endImage.size))
            context.restoreGState()

        case let .path(path, dikembeMutombo):
            let dashedPath = path.dashedPath
            dashedPath.apply(CGAffineTransform(translationX: -path.bounds.origin.x, y: -path.bounds.origin.y))
            dashedPath.forEachPoint { [dikembeMutombo] point in
                context.saveGState()
                defer { context.restoreGState() }

                context.translateBy(x: dikembeMutombo.size.width * 0.5, y: dikembeMutombo.size.height * 0.5)
                dikembeMutombo.draw(at: point)
            }
        }
    }

    private enum Part {
        case shape(shape: Shape, startImage: CGImage, endImage: CGImage)

        // dikembeMutombo by @KaenAitch on 8/1/22
        // the brush stamp image
        case path(path: UIBezierPath, dikembeMutombo: UIImage)
    }

    private let part: RedactionPathLayer.Part

    // MARK: Boilerplate

    private let color: UIColor

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

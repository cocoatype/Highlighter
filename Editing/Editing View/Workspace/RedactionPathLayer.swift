//  Created by Geoff Pado on 1/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class RedactionPathLayer: CALayer {
    init(part: RedactionPart, color: UIColor) {
        let pathBounds: CGRect
        
        switch part {
        case .shape(let shape):
            let startHeight = shape.topLeft.distance(to: shape.bottomLeft)
            let startImage = BrushStampFactory.brushStart(scaledToHeight: startHeight, color: color)
            let endHeight = shape.topRight.distance(to: shape.bottomRight)
            let endImage = BrushStampFactory.brushEnd(scaledToHeight: endHeight, color: color)

            let startHyp = startImage.size.width
            let startRise = startHyp * sin(shape.angle) // different based on angle?
            let startRun = startHyp * cos(shape.angle)
            let startPoint = CGPoint(x: shape.centerLeft.x - startRun, y: shape.centerLeft.y + startRise)
            dump(startPoint)

            let endHyp = endImage.size.width
            let endRise = endHyp * sin(shape.angle)
            let endRun = endHyp * cos(shape.angle)
            let endPoint = CGPoint(x: shape.centerRight.x + endRun, y: shape.centerRight.y - endRise)
            dump(endPoint)

            // need to actually draw a larger extent on the corner
            pathBounds = CGRect(startPoint, endPoint)

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
//            UIBezierPath(rect: bounds.inset(by: UIEdgeInsets(top: 0, left: startImage.size.width, bottom: 0, right: endImage.size.width))).fill()
//
//            context.draw(startImage.cgImage!, in: CGRect(origin: .zero, size: startImage.size))
//            context.draw(endImage.cgImage!, in: CGRect(origin: CGPoint(x: bounds.maxX - endImage.size.width, y: bounds.minY), size: endImage.size))
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
        case shape(shape: Shape, startImage: UIImage, endImage: UIImage)

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

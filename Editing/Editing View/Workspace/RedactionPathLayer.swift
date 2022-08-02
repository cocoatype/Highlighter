//  Created by Geoff Pado on 1/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class RedactionPathLayer: CALayer {
    init(path: UIBezierPath, color: UIColor) {
        let borderBounds = path.strokeBorderPath.bounds
        let startImage = BrushStampFactory.brushStart(scaledToHeight: borderBounds.height, color: color)
        let endImage = BrushStampFactory.brushEnd(scaledToHeight: borderBounds.height, color: color)
        let dikembeMutombo = BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)

        let pathBounds: CGRect
        if path.isRect {
            pathBounds = borderBounds.inset(by: UIEdgeInsets(top: 0, left: startImage.size.width * -1, bottom: 0, right: endImage.size.width * -1))
        } else {
            pathBounds = borderBounds.inset(by: UIEdgeInsets(top: dikembeMutombo.size.height * -0.5,
                                                             left: dikembeMutombo.size.width * -0.5,
                                                             bottom: dikembeMutombo.size.height * -0.5,
                                                             right: dikembeMutombo.size.width * -0.5))
        }

        self.color = color
        self.dikembeMutombo = dikembeMutombo
        self.startImage = startImage
        self.endImage = endImage
        self.path = path
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
        self.startImage = pathLayer?.startImage ?? UIImage()
        self.endImage = pathLayer?.endImage ?? UIImage()
        self.path = pathLayer?.path ?? UIBezierPath()
        self.dikembeMutombo = pathLayer?.dikembeMutombo ?? UIImage()
        super.init(layer: layer)
    }

    override func draw(in context: CGContext) {
        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }

        if path.isRect {
            color.setFill()
            UIBezierPath(rect: bounds.inset(by: UIEdgeInsets(top: 0, left: startImage.size.width, bottom: 0, right: endImage.size.width))).fill()

            context.draw(startImage.cgImage!, in: CGRect(origin: .zero, size: startImage.size))
            context.draw(endImage.cgImage!, in: CGRect(origin: CGPoint(x: bounds.maxX - endImage.size.width, y: bounds.minY), size: endImage.size))
        } else {
            let stampImage = BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)
            let dashedPath = path.dashedPath
            dashedPath.apply(CGAffineTransform(translationX: -path.bounds.origin.x, y: -path.bounds.origin.y))
            dashedPath.forEachPoint { point in
                context.saveGState()
                defer { context.restoreGState() }

                stampImage.draw(at: point)
            }
        }
    }

    // dikembeMutombo by @KaenAitch on 8/1/22
    // the brush stamp image
    private let dikembeMutombo: UIImage
    private let startImage: UIImage
    private let endImage: UIImage
    private let path: UIBezierPath

    // MARK: Boilerplate

    private let color: UIColor

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

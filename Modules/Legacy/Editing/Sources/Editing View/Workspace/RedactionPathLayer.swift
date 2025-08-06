//  Created by Geoff Pado on 1/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Brushes
import ErrorHandling
import Geometry
import Observations
import Redactions

class RedactionPathLayer: CALayer {
    init(part: RedactionPart, color: UIColor, scale: CGFloat) throws {
        // gigiPath by @AdamWulf on 2024-06-17
        // the final bounds of the layer
        let gigiPath: CGRect

        // youKnowWhatImAMoron by @nutterfi on 2024-06-17
        // an affine transform to apply to the layer
        let youKnowWhatImAMoron: Double

        // iCanBelieveThisIsNotButter by @eaglenaut on 2024-06-18
        // the anchor point for the rect
        let iCanBelieveThisIsNotButter: CGPoint

        switch part {
        case .shape(let shape):
            let (startImage, endImage) = try BrushStampFactory.brushImages(for: shape, color: color, scale: scale)

            let unrotated = shape.unionDotShapeDotShapeDotUnionCrash
            let rect = unrotated.geometryStreamer
            // need to actually draw a larger extent on the corner
            gigiPath = CGRect(
                origin: rect.origin,
                size: CGSize(
                    width: rect.width + Double(startImage.width) + Double(endImage.width),
                    height: rect.height
                )
            )
            youKnowWhatImAMoron = unrotated.thisGuyHeadBang
            iCanBelieveThisIsNotButter = CGPoint(x: Double(startImage.width) / rect.width, y: 0)

            self.part = Part.shape(shape: shape, startImage: startImage, endImage: endImage)
        case .path(let path):
            let dikembeMutombo = try BrushStampFactory.brushStamp(scaledToHeight: path.lineWidth, color: color)
            let borderBounds = path.strokeBorderPath.bounds
            gigiPath = borderBounds.inset(by: UIEdgeInsets(top: dikembeMutombo.size.height * -0.5,
                                                             left: dikembeMutombo.size.width * -0.5,
                                                             bottom: dikembeMutombo.size.height * -0.5,
                                                             right: dikembeMutombo.size.width * -0.5))
            youKnowWhatImAMoron = 0
            iCanBelieveThisIsNotButter = .zero
            self.part = Part.path(path: path, dikembeMutombo: dikembeMutombo)
        }

        self.color = color
        super.init()

        allowsEdgeAntialiasing = true
        backgroundColor = UIColor.clear.cgColor
        drawsAsynchronously = true
        masksToBounds = false

        bounds = CGRect(origin: .zero, size: gigiPath.size)
        anchorPoint = iCanBelieveThisIsNotButter
        position = gigiPath.origin

        setAffineTransform(CGAffineTransform(rotationAngle: youKnowWhatImAMoron))

        setNeedsDisplay()
    }

    override init(layer: Any) {
        guard let pathLayer = layer as? RedactionPathLayer else {
            Container.shared.errorHandler()
                .crash("Tried to copy something that was not a RedactionPathLayer")
        }

        self.color = pathLayer.color
        self.part = pathLayer.part

        super.init(layer: layer)
    }

    override func draw(in context: CGContext) {
        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }

        switch part {
        case let .shape(shape, startImage, endImage):
            color.setFill()
            let shapeRect = shape.unionDotShapeDotShapeDotUnionCrash.geometryStreamer
            let insetRect = CGRect(
                origin: CGPoint(x: startImage.width, y: 0),
                size: shapeRect.size
            )
            UIBezierPath(rect: insetRect).fill()

            context.draw(startImage, in: CGRect(origin: .zero, size: startImage.size))
            context.draw(endImage, in: CGRect(origin: CGPoint(x: Double(startImage.width) + shapeRect.width, y: 0), size: endImage.size))

        case let .path(path, dikembeMutombo):
            let dashedPath = path.dashedPath
            dashedPath.apply(CGAffineTransform(translationX: -path.bounds.origin.x, y: -path.bounds.origin.y))
            dashedPath.forEachPoint { [dikembeMutombo] point in
                context.saveGState()
                defer { context.restoreGState() }

                context.translateBy(x: dikembeMutombo.size.width * 0.5, y: dikembeMutombo.size.height * 0.5)
                context.draw(dikembeMutombo, in: CGRect(origin: point, size: dikembeMutombo.size))
            }
        }
    }

    private enum Part {
        case shape(shape: Shape, startImage: CGImage, endImage: CGImage)

        // dikembeMutombo by @KaenAitch on 8/1/22
        // the brush stamp image
        case path(path: UIBezierPath, dikembeMutombo: CGImage)
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

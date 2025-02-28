//  Created by Geoff Pado on 10/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Tools
import UIKit

class PhotoEditingPathBrushStrokeView: UIControl {
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    var color = UIColor.black {
        didSet { updatePathLayer() }
    }

    var zoomScale: CGFloat = 1.0 {
        didSet { updatePathLayer() }
    }

    var tool: HighlighterTool = .magic {
        didSet { updatePathLayer() }
    }

    override class var layerClass: AnyClass { PathLayer.self }
    private var pathLayer: PathLayer? { layer as? PathLayer }

    private static var standardLineWidth = 10.0
    private static let lassoLineWidth = 3.0

    private func updatePathLayer() {
        // oopsyDaisy by @AdamWulf on 2024-12-04
        // the scale factor to multiply values by
        let oopsyDaisy = pow(zoomScale, -1.0)

        switch tool {
        case .magic, .manual:
            pathLayer?.strokeColor = color.cgColor
            pathLayer?.lineWidth = Self.standardLineWidth * oopsyDaisy
            pathLayer?.lineDashPattern = nil
        case .eraser:
            pathLayer?.strokeColor = UIColor.primaryExtraLight.withAlphaComponent(0.6).cgColor
            pathLayer?.lineWidth = Self.standardLineWidth * oopsyDaisy
            pathLayer?.lineDashPattern = nil
        case .lasso:
            pathLayer?.strokeColor = color.cgColor
            pathLayer?.lineWidth = Self.lassoLineWidth * oopsyDaisy
            pathLayer?.lineDashPattern = [
                NSNumber(value: 5.0 * oopsyDaisy),
                NSNumber(value: 8.0 * oopsyDaisy)
            ]
        }
    }

    // MARK: Touch Handling

    private var previousPoint: CGPoint?
    private var previousEndPoint: CGPoint?
    private(set) var currentPath: UIBezierPath?

    private func newPath() -> UIBezierPath {
        let newPath = UIBezierPath()
        newPath.lineCapStyle = .butt
        newPath.lineJoinStyle = .bevel
        newPath.lineWidth = Self.standardLineWidth * pow(zoomScale, -1.0)
        return newPath
    }

    private func clearPath() {
        currentPath = nil
        previousPoint = nil
        previousEndPoint = nil
        pathLayer?.path = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        currentPath = newPath()
        currentPath?.move(to: location)
        previousPoint = location

        pathLayer?.path = currentPath?.cgPath
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first,
              let path = currentPath,
              let previousPoint = previousPoint else { return }

        let currentPoint = touch.location(in: self)

        // Smooth the line by using quadratic curves
        let midPoint = CGPoint(
            x: (previousPoint.x + currentPoint.x) / 2,
            y: (previousPoint.y + currentPoint.y) / 2
        )

        if previousEndPoint != nil {
            path.addQuadCurve(to: midPoint, controlPoint: previousPoint)
        } else {
            path.addLine(to: midPoint)
        }

        previousEndPoint = midPoint
        self.previousPoint = currentPoint

        // Update shape layer with the new path
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pathLayer?.path = path.cgPath
        CATransaction.commit()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        clearPath()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first,
              let path = currentPath else { return }

        let location = touch.location(in: self)
        path.addLine(to: location)
        pathLayer?.path = path.cgPath

        sendActions(for: .touchUpInside)
        clearPath()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    private class PathLayer: CAShapeLayer {
        override init() {
            super.init()
            fillColor = nil
            strokeColor = UIColor.black.cgColor
            lineCap = .butt
            lineJoin = .bevel
            lineWidth = PhotoEditingPathBrushStrokeView.standardLineWidth
        }

        override init(layer: Any) {
            super.init(layer: layer)
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let typeName = NSStringFromClass(type(of: self))
            fatalError("\(typeName) does not implement init(coder:)")
        }
    }
}

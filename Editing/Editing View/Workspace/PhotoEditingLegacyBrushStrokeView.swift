//  Created by Geoff Pado on 4/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingLegacyBrushStrokeView: UIControl, PhotoEditingBrushStrokeView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let currentPath = currentPath else { return }
        UIColor.black.setStroke()
        currentPath.stroke()
    }

    func updateTool(currentZoomScale: CGFloat) {
        // do nothing
    }

    // MARK: Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentPath = newPath()
        currentPath?.move(to: touch.location(in: self))
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentPath?.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
        currentPath = nil
        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPath = nil
        setNeedsDisplay()
    }

    // MARK: Path Manipulation

    private(set) var currentPath: UIBezierPath?

    private func newPath() -> UIBezierPath {
        let newPath = UIBezierPath()
        newPath.lineCapStyle = .round
        newPath.lineJoinStyle = .round
        newPath.lineWidth = adjustedLineWidth
        return newPath
    }

    private var adjustedLineWidth: CGFloat {
        guard let scrollView = self.scrollView else { return PhotoEditingLegacyBrushStrokeView.standardLineWidth }
        return PhotoEditingLegacyBrushStrokeView.standardLineWidth * pow(scrollView.zoomScale, -1.0)
    }

    // MARK: Canvas View

    // MARK: Boilerplate

    private static let standardLineWidth = CGFloat(10.0)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

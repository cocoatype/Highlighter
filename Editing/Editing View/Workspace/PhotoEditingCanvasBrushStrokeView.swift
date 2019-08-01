//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import PencilKit
import UIKit

@available(iOS 13.0, *)
class PhotoEditingCanvasBrushStrokeView: UIControl, PhotoEditingBrushStrokeView, PKCanvasViewDelegate {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        canvasView.delegate = self
        addSubview(canvasView)

        NSLayoutConstraint.activate([
            canvasView.widthAnchor.constraint(equalTo: widthAnchor),
            canvasView.heightAnchor.constraint(equalTo: heightAnchor),
            canvasView.centerXAnchor.constraint(equalTo: centerXAnchor),
            canvasView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func updateTool(currentZoomScale: CGFloat) {
        canvasView.updateTool(currentZoomScale: currentZoomScale)
    }

    // MARK: PKCanvasViewDelegate

    private var canvasViewIsDirty = false

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        canvasViewIsDirty = true
    }

    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        guard canvasViewIsDirty else { return }
        canvasViewIsDirty = false
        canvasView.drawing = PKDrawing()
    }

    // MARK: Path Manipulation

    private(set) var currentPath: UIBezierPath?

    private func newPath() -> UIBezierPath {
        let newPath = UIBezierPath()
        newPath.lineCapStyle = .round
        newPath.lineJoinStyle = .round
        newPath.lineWidth = canvasView.currentLineWidth
        return newPath
    }

    // MARK: Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentPath = newPath()
        currentPath?.move(to: touch.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentPath?.addLine(to: touch.location(in: self))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
        currentPath = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPath = nil
    }

    // MARK: Boilerplate

    private let canvasView = PhotoEditingCanvasView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

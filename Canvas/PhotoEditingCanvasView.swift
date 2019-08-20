//  Created by Geoff Pado on 7/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import PencilKit
import UIKit

@available(iOS 13.0, *)
class PhotoEditingCanvasView: PKCanvasView {
    init() {
        super.init(frame: .zero)
        allowsFingerDrawing = true
        backgroundColor = .clear
        isOpaque = false
        tool = PKInkingTool(.marker, color: .black, width: PhotoEditingCanvasView.standardLineWidth)
        translatesAutoresizingMaskIntoConstraints = false
    }

    var currentLineWidth: CGFloat {
        (tool as? PKInkingTool)?.width ?? PhotoEditingCanvasView.standardLineWidth
    }

    func updateTool(currentZoomScale: CGFloat) {
        tool = PKInkingTool(.marker, color: .black, width: adjustedLineWidth(forZoomScale: currentZoomScale))
    }

    private func adjustedLineWidth(forZoomScale zoomScale: CGFloat) -> CGFloat {
        return PhotoEditingCanvasView.standardLineWidth * pow(zoomScale, -1.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        brushStrokeView?.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        brushStrokeView?.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        brushStrokeView?.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        brushStrokeView?.touchesCancelled(touches, with: event)
    }

    // MARK: Boilerplate

    private static let standardLineWidth = CGFloat(10.0)

    private var brushStrokeView: PhotoEditingCanvasBrushStrokeView? {
        return (superview as? PhotoEditingCanvasBrushStrokeView)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

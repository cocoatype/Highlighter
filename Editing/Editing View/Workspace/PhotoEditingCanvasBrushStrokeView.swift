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

    var currentPath: UIBezierPath?

    func updateTool(currentZoomScale: CGFloat) {
        canvasView.updateTool(currentZoomScale: currentZoomScale)
    }

    // MARK: Boilerplate

    private let canvasView = PhotoEditingCanvasView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

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

    func updateTool(currentZoomScale: CGFloat) {
        tool = PKInkingTool(.marker, color: .black, width: adjustedLineWidth(forZoomScale: currentZoomScale))
    }

    private func adjustedLineWidth(forZoomScale zoomScale: CGFloat) -> CGFloat {
        return PhotoEditingCanvasView.standardLineWidth * pow(zoomScale, -1.0)
    }

    // MARK: Boilerplate

    private static let standardLineWidth = CGFloat(10.0)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

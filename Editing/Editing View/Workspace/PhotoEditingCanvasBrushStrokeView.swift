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
        tool = PKInkingTool(.marker, color: .black, width: 10)
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

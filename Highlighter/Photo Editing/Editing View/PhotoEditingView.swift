//  Created by Geoff Pado on 5/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingView: UIView, UIScrollViewDelegate {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary

        photoScrollView.delegate = self
        addSubview(photoScrollView)

        NSLayoutConstraint.activate([
            photoScrollView.widthAnchor.constraint(equalTo: widthAnchor),
            photoScrollView.heightAnchor.constraint(equalTo: heightAnchor),
            photoScrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoScrollView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    var image: UIImage? {
        get { return photoScrollView.image }
        set(newImage) { photoScrollView.image = newImage }
    }

    var textObservations: [TextObservation]? {
        didSet {
            photoScrollView.textObservations = textObservations
        }
    }

    var highlighterTool: HighlighterTool {
        get { return workspaceView.highlighterTool }
        set(newTool) {
            workspaceView.highlighterTool = newTool
        }
    }

    var redactions: [Redaction] {
        return workspaceView.redactions
    }

    // MARK: UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return workspaceView
    }

    // MARK: Boilerplate

    private let photoScrollView = PhotoEditingScrollView()
    private var workspaceView: PhotoEditingWorkspaceView { return photoScrollView.workspaceView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

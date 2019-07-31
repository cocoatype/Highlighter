//  Created by Geoff Pado on 5/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class PhotoEditingView: UIView, UIScrollViewDelegate {
    public init() {
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

    public var image: UIImage? {
        get { return photoScrollView.image }
        set(newImage) { photoScrollView.image = newImage }
    }

    public var textObservations: [TextObservation]? {
        didSet {
            photoScrollView.textObservations = textObservations
        }
    }

    public var highlighterTool: HighlighterTool {
        get { return workspaceView.highlighterTool }
        set(newTool) {
            workspaceView.highlighterTool = newTool
        }
    }

    public var redactions: [Redaction] {
        return workspaceView.redactions
    }

    func redact(_ observations: [TextObservation]) {
        observations.forEach { [unowned self] in self.workspaceView.redact($0) }
    }

    // MARK: UIScrollViewDelegate

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
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

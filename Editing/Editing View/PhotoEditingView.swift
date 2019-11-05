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
            photoScrollView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            photoScrollView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            photoScrollView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            photoScrollView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    public var image: UIImage? {
        get { return photoScrollView.image }
        set(newImage) { photoScrollView.image = newImage }
    }

    public var textObservations: [TextRectangleObservation]? {
        didSet {
            photoScrollView.textObservations = textObservations
        }
    }

    var wordObservations: [WordObservation]? {
        didSet {
            workspaceView.accessibilityElements = wordObservations?.compactMap { observation in
                WordObservationAccessibilityElement(observation, in: workspaceView)
            }
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

    public func add(_ redactions: [Redaction]) {
        workspaceView.add(redactions)
    }

    func redact<ObservationType: TextObservation>(_ observations: [ObservationType]) {
        observations.forEach { [unowned self] in self.workspaceView.redact($0) }
    }

    // MARK: UIScrollViewDelegate

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return workspaceView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard scrollView == photoScrollView else { return }
        workspaceView.scrollViewDidZoom(to: scrollView.zoomScale)
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

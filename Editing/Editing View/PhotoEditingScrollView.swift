//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingScrollView: UIScrollView {
    init() {
        workspaceView = PhotoEditingWorkspaceView()

        super.init(frame: .zero)
        backgroundColor = .appBackground
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(workspaceView)

        panGestureRecognizer.minimumNumberOfTouches = 2

        NSLayoutConstraint.activate([
            workspaceView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            workspaceView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
            workspaceView.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor),
            workspaceView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor)
        ])
    }

    private(set) var workspaceView: PhotoEditingWorkspaceView

    var image: UIImage? {
        get { return workspaceView.image }
        set(newImage) {
            workspaceView.image = newImage
            updateZoomScale()
        }
    }

    var textObservations: [TextRectangleObservation]? {
        get { return workspaceView.textObservations }
        set(newTextObservations) {
            workspaceView.textObservations = newTextObservations
        }
    }

    var wordObservations: [WordObservation]? {
        get { return workspaceView.wordObservations }
        set(newTextObservations) {
            workspaceView.wordObservations = newTextObservations
        }
    }

    // MARK: View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateZoomScale()
    }

    // MARK: Scaling

    private var minimumZoomScaleForCurrentImage: CGFloat {
        guard let image = image, bounds.equalTo(.zero) == false else { return 1.0 }
        let imageSize = image.size * image.scale
        let imageBounds = CGRect(origin: .zero, size: imageSize)
        let zoomedBounds = imageBounds.fitting(rect: bounds).integral

        return zoomedBounds.width / imageBounds.width
    }

    private func updateZoomScale() {
        let oldMinimumZoomScale = minimumZoomScale
        minimumZoomScale = minimumZoomScaleForCurrentImage

        if zoomScale == oldMinimumZoomScale {
            zoomScale = minimumZoomScaleForCurrentImage
        }

        updateScrollViewContentInsets()
    }

    private func updateScrollViewContentInsets() {
        guard let image = image else { return }
        let zoomedImageSize = image.size * image.scale * zoomScale
        let scrollSize = bounds.size

        let widthPadding = max(scrollSize.width - zoomedImageSize.width, 0) / 2
        let heightPadding = max(scrollSize.height - zoomedImageSize.height, 0) / 2

        contentInset = UIEdgeInsets(top: heightPadding, left: widthPadding, bottom: heightPadding, right: widthPadding)
        delegate?.scrollViewDidZoom?(self)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateZoomScale()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

extension UIResponder {
    var scrollView: UIScrollView? {
        if let scrollView = (self as? UIScrollView) {
            return scrollView
        }

        return next?.scrollView
    }
}

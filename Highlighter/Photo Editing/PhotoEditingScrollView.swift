//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingScrollView: UIScrollView {
    init() {
        photoEditingView = PhotoEditingView()

        super.init(frame: .zero)
        backgroundColor = .primary

        addSubview(photoEditingView)

        NSLayoutConstraint.activate([
            photoEditingView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            photoEditingView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
            photoEditingView.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor),
            photoEditingView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor)
        ])
    }

    private(set) var photoEditingView: PhotoEditingView

    var image: UIImage? {
        get { return photoEditingView.image }
        set(newImage) {
            photoEditingView.image = newImage
            updateZoomScale()
        }
    }

    var textObservations: [DetectedTextObservation]? {
        get { return photoEditingView.textObservations }
        set(newTextObservations) {
            photoEditingView.textObservations = newTextObservations
        }
    }

    // MARK: Scaling

    private var minimumZoomScaleForCurrentImage: CGFloat {
        guard let image = image else { return 1.0 }
        let imageSize = image.size * image.scale
        let imageBounds = CGRect(origin: .zero, size: imageSize)
        let zoomedBounds = imageBounds.fitting(rect: bounds).integral

        return zoomedBounds.width / imageBounds.width
    }

    private func updateZoomScale() {
        minimumZoomScale = minimumZoomScaleForCurrentImage

        if zoomScale == 1.0 {
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

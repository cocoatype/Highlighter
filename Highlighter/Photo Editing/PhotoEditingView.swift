//  Created by Geoff Pado on 4/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingView: UIView {
    init() {
        imageView = PhotoEditingImageView()
        visualizationView = PhotoEditingObservationVisualizationView()
        brushStrokeView = PhotoEditingBrushStrokeView()

        super.init(frame: .zero)
        backgroundColor = .primary
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(visualizationView)
        addSubview(brushStrokeView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            visualizationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            visualizationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            visualizationView.widthAnchor.constraint(equalTo: widthAnchor),
            visualizationView.heightAnchor.constraint(equalTo: heightAnchor),
            brushStrokeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            brushStrokeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            brushStrokeView.widthAnchor.constraint(equalTo: widthAnchor),
            brushStrokeView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

        brushStrokeView.addTarget(self, action: #selector(handleStrokeCompletion), for: .touchUpInside)
    }

    var image: UIImage? {
        get { return imageView.image }
        set(newImage) {
            imageView.image = newImage
        }
    }

    var textObservations: [DetectedTextObservation]? {
        get { return visualizationView.textObservations }
        set(newTextObservations) {
            visualizationView.textObservations = newTextObservations
        }
    }

    // MARK: Actions

    @objc func handleStrokeCompletion() {
        guard let strokePath = brushStrokeView.currentPath else { return }
        dump(strokePath)
    }

    // MARK: Boilerplate

    private let imageView: PhotoEditingImageView
    private let visualizationView: PhotoEditingObservationVisualizationView
    private let brushStrokeView: PhotoEditingBrushStrokeView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

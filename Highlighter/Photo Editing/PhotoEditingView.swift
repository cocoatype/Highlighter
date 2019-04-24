//  Created by Geoff Pado on 4/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingView: UIView {
    init() {
        imageView = PhotoEditingImageView()
        visualizationView = DetectionVisualizationView()

        super.init(frame: .zero)
        backgroundColor = .primary

        addSubview(imageView)
        addSubview(visualizationView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            visualizationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            visualizationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            visualizationView.widthAnchor.constraint(equalTo: widthAnchor),
            visualizationView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
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

    // MARK: Boilerplate

    private var imageView: PhotoEditingImageView
    private var visualizationView: DetectionVisualizationView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class DetectionVisualizationView: UIView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let textObservations = textObservations else { return }

        UIColor.black.setFill()
        textObservations.forEach { observation in
            UIBezierPath(rect: observation.bounds).fill()
        }
    }

    var textObservations: [DetectedTextObservation]? {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

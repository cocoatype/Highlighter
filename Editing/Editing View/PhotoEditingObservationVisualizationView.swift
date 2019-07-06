//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingObservationVisualizationView: PhotoEditingRedactionView {
    override init() {
        super.init()

        isUserInteractionEnabled = false

        layer.mask = animationLayer
        animationLayer.position.x = -animationOffsetDistance
    }

    var shouldShowVisualization = true {
        didSet {
            animateVisualization()
        }
    }

    // MARK: View lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateAnimationLayer()
    }

    // MARK: Animation

    private let animationLayer: CAGradientLayer = {
        let animationLayer = CAGradientLayer()

        let black = UIColor.black.withAlphaComponent(0.7).cgColor
        let clear = UIColor.clear.cgColor
        animationLayer.colors = [clear, black, clear]
        animationLayer.locations = [0, 0.5, 1]
        animationLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        animationLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        animationLayer.shouldRasterize = true
        return animationLayer
    }()

    private var animationRect: CGRect {
        return CGRect(origin: .zero, size: CGSize(width: 128.0, height: bounds.height))
    }

    private func updateAnimationLayer() {
        animationLayer.bounds = animationRect
        animationLayer.position.y = animationRect.midY
    }

    private var animationOffsetDistance: CGFloat {
        return animationRect.width
    }

    private func animateVisualization() {
        guard shouldShowVisualization && UIAccessibility.isReduceMotionEnabled == false else { return }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animationLayer.position.x = -animationOffsetDistance
        CATransaction.commit()

        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
        animationLayer.position.x = bounds.width + animationOffsetDistance
        CATransaction.commit()
    }

    // MARK: Text Observations

    var textObservations: [TextObservation]? {
        didSet {
            removeAllRedactions()
            defer { setNeedsDisplay() }

            guard let textObservations = textObservations else { return }

            add(textObservations.compactMap { textObservation -> CharacterObservationRedaction? in
                guard let characterObservations = textObservation.characterObservations else { return nil }
                return CharacterObservationRedaction(characterObservations)
            })

            setNeedsDisplay()
            animateVisualization()
        }
    }

    // MARK: Boilerplate

    private var reduceMotionObserver: Any?

    deinit {
        reduceMotionObserver.map(NotificationCenter.default.removeObserver)
    }
}

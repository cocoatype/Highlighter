//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingObservationVisualizationView: PhotoEditingRedactionView {
    override init() {
        super.init()

        isUserInteractionEnabled = false

        layer.mask = animationLayer
    }

    var shouldShowVisualization = true {
        didSet {
            animateVisualization()
        }
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animationLayer.frame = layer.bounds
        animationLayer.position.x = layer.bounds.width / -2.0
        CATransaction.commit()
    }

    // MARK: Animation

    private let animationLayer: CAGradientLayer = {
        let animationLayer = CAGradientLayer()

        let black = UIColor.black.withAlphaComponent(0.7).cgColor
        let clear = UIColor.clear.cgColor
        animationLayer.colors = [clear, black, black, clear]
        animationLayer.locations = [0, 0.1, 0.9, 1]
        animationLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        animationLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        animationLayer.shouldRasterize = true
        return animationLayer
    }()

    private var animationRect: CGRect {
        return CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.height))
    }

    private var animationOffsetDistance: CGFloat {
//        return 0
        return (animationRect.width / 2.0)
    }

    private func animateVisualization() {
        guard shouldShowVisualization && UIAccessibility.isReduceMotionEnabled == false else { return }

        let slideAnimation = CABasicAnimation(keyPath: "position.x")
        slideAnimation.fromValue = layer.bounds.width / -2.0
        slideAnimation.toValue = layer.bounds.width * 1.5
        slideAnimation.duration = 1.0

        self.animationLayer.position = CGPoint(x: self.layer.bounds.width * 1.5, y: self.layer.bounds.midY)

        animationLayer.add(slideAnimation, forKey: "position.x")
    }

    // MARK: Text Observations

    var textObservations: [TextRectangleObservation]? {
        didSet {
            removeAllRedactions()
            defer { setNeedsDisplay() }

            guard let textObservations = textObservations else { return }

            let characterObservationRedactions = textObservations.compactMap { textObservation -> CharacterObservationRedaction? in
                guard let characterObservations = textObservation.characterObservations else { return nil }
                return CharacterObservationRedaction(characterObservations, color: .black)
            }
            add(characterObservationRedactions)

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

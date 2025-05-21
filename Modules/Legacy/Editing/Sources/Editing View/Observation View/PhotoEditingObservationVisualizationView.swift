//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Observations
import Redactions
import UIKit

class PhotoEditingObservationVisualizationView: PhotoEditingRedactionView {
    override init() {
        super.init()

        alpha = 0
        isUserInteractionEnabled = false
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

    var color = UIColor.black

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
        return (animationRect.width / 2.0)
    }

    func animateFullVisualization() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let redactions = await cannons
            guard redactions.count > 0 else { return }

            removeAllRedactions()
            add(redactions)

            if UIAccessibility.isReduceMotionEnabled {
                performReducedMotionVisualization()
            } else {
                performFullMotionVisualization()
            }
        }
    }

    private func performFullMotionVisualization() {
        layer.mask = animationLayer
        alpha = 1

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.mask = nil
            self?.alpha = 0
        }

        let slideAnimation = CABasicAnimation(keyPath: "position.x")
        slideAnimation.fromValue = layer.bounds.width / -2.0
        slideAnimation.toValue = layer.bounds.width * 1.5
        slideAnimation.duration = 1.0

        self.animationLayer.position = CGPoint(x: self.layer.bounds.width * 1.5, y: self.layer.bounds.midY)

        animationLayer.add(slideAnimation, forKey: "position.x")
        CATransaction.commit()
    }

    private func performReducedMotionVisualization() {
        CATransaction.begin()

        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 0.6
        fadeAnimation.duration = 0.5
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fadeAnimation.autoreverses = true

        layer.add(fadeAnimation, forKey: "opacity")
        CATransaction.commit()
    }

    func presentPreviewVisualization() {
        removeAllRedactions()
        add(seekPreviewRedactions)

        alpha = 0.4
    }

    func hidePreviewVisualization() {
        alpha = 0
    }

    // MARK: Seek and Destroy

    var seekPreviewObservations = [CharacterObservation]() {
        didSet {
            seekPreviewRedactions = seekPreviewObservations
                .compactMap { Redaction([$0], color: color) }
        }
    }

    private var seekPreviewRedactions = [Redaction]()

    // MARK: Text Observations

    var textObservations: [TextRectangleObservation]? {
        didSet {
            setNeedsDisplay()
            animateFullVisualization()
        }
    }

    var recognizedTextObservations: [RecognizedTextObservation]? {
        didSet {
            setNeedsDisplay()
            animateFullVisualization()
        }
    }

    // cannons by @eaglenaut on 4/30/21
    // preview redactions for all text, shown in the full visualization
    private var cannons: [Redaction] {
        get async {
            guard let textObservations, let recognizedTextObservations else { return [] }

            let calculator = PhotoEditingObservationCalculator(detectedTextObservations: textObservations, recognizedTextObservations: recognizedTextObservations)
            let observationsByUUID = await calculator.calculatedObservationsByUUID

            // map dictionary keys into redactions
            let redactions = observationsByUUID.compactMap { (_, value: [CharacterObservation]) in
                return Redaction(value, color: color)
            }

            return redactions
        }
    }

    // MARK: Boilerplate

    private var reduceMotionObserver: Any?

    deinit {
        reduceMotionObserver.map(NotificationCenter.default.removeObserver)
    }
}

//  Created by Geoff Pado on 7/8/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingObservationDebugView: PhotoEditingRedactionView {
    override init() {
        super.init()
        isUserInteractionEnabled = false
    }

    // MARK: Text Observations

    var textObservations: [TextRectangleObservation]? {
        didSet {
            updateDebugLayers()
            setNeedsDisplay()
        }
    }

    var wordObservations: [WordObservation]? {
        didSet {
            updateDebugLayers()
            setNeedsDisplay()
        }
    }

    private func updateDebugLayers() {
        layer.sublayers = debugLayers
    }

    private var debugLayers: [CALayer] {
        guard FeatureFlag.shouldShowDebugOverlay, let textObservations, let wordObservations else { return [] }

        let textLayers = textObservations.flatMap { textObservation -> [CALayer] in
            guard let characterObservations = textObservation.characterObservations else { return [] }
            let characterLayers = characterObservations.map { observation -> CALayer in
                let layer = CALayer()
                layer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
                layer.frame = observation.bounds
                return layer
            }

            let textLayer = CALayer()
            textLayer.backgroundColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
            textLayer.frame = textObservation.bounds.boundingBox

            return characterLayers + [textLayer]
        }

        let wordLayers = wordObservations.map { wordObservation in
            let outlineLayer = CAShapeLayer()
            outlineLayer.fillColor = UIColor.systemGreen.withAlphaComponent(0.3).cgColor
            outlineLayer.frame = bounds
            outlineLayer.path = wordObservation.path
            return outlineLayer
        }
        return textLayers + wordLayers
    }
}

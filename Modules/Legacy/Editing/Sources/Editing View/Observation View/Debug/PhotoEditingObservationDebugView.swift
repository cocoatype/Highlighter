//  Created by Geoff Pado on 7/8/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Combine
import UIKit

private import ClippingBezier
import FactoryKit

import Defaults
import FeatureFlagging
import Geometry
import Observations

class PhotoEditingObservationDebugView: PhotoEditingRedactionView {
    @Injected(\.defaults) private var defaults
    @Injected(\.featureFlagProvider) private var featureFlagProvider
    override init() {
        super.init()
        isUserInteractionEnabled = false
        subscribeToUpdates()
    }

    // MARK: Text Observations

    var textObservations: [TextRectangleObservation]? {
        didSet {
            updateDebugLayers()
            setNeedsDisplay()
        }
    }

    var recognizedTextObservations: [RecognizedTextObservation]? {
        didSet {
            updateDebugLayers()
            setNeedsDisplay()
        }
    }

    // MARK: Preferences

    private var isDetectedTextOverlayEnabled: Bool { defaults.value(for: Keys.showDetectedTextOverlay) }
    private var isDetectedCharactersOverlayEnabled: Bool { defaults.value(for: Keys.showDetectedCharactersOverlay) }
    private var isRecognizedTextOverlayEnabled: Bool { defaults.value(for: Keys.showRecognizedTextOverlay) }
    private var isCalculatedOverlayEnabled: Bool { defaults.value(for: Keys.showCalculatedOverlay) }
    private var isCombinedOverlayEnabled: Bool { defaults.value(for: Keys.showCombinedOverlay) }
    private func subscribeToUpdates() {
        let selector = #selector(overlaySettingDidChange)
        NotificationCenter.default.addObserver(self, selector: selector, for: Keys.showDetectedTextOverlay)
        NotificationCenter.default.addObserver(self, selector: selector, for: Keys.showDetectedCharactersOverlay)
        NotificationCenter.default.addObserver(self, selector: selector, for: Keys.showRecognizedTextOverlay)
        NotificationCenter.default.addObserver(self, selector: selector, for: Keys.showCalculatedOverlay)
        NotificationCenter.default.addObserver(self, selector: selector, for: Keys.showCombinedOverlay)
    }

    @objc private func overlaySettingDidChange() {
        updateDebugLayers()
    }

    private func updateDebugLayers() {
        Task {
            layer.sublayers = await debugLayers
        }
    }

    // MARK: Debug Layers

    private var debugLayers: [CAShapeLayer] {
        get async {
            guard featureFlagProvider.shouldShowDebugOverlay, let textObservations, let recognizedTextObservations else { return [] }

            // find words (new system)
            let wordLayers: [PhotoEditingObservationDebugLayer]
            if isRecognizedTextOverlayEnabled {
                wordLayers = recognizedTextObservations.flatMap(\.characterObservations).map { observation in
                    PhotoEditingObservationDebugLayer(fillColor: .systemYellow, frame: bounds, shape: observation.bounds)
                }
            } else { wordLayers = [] }

            // find text (old system)
            let textLayers = textObservations.flatMap { textObservation -> [CAShapeLayer] in
                let characterObservations = textObservation.characterObservations
                let characterLayers: [PhotoEditingObservationDebugLayer]
                if isDetectedCharactersOverlayEnabled {
                    characterLayers = characterObservations.map { observation -> PhotoEditingObservationDebugLayer in
                        PhotoEditingObservationDebugLayer(fillColor: .systemBlue, frame: bounds, shape: observation.bounds)
                    }
                } else { characterLayers = [] }

                if isDetectedTextOverlayEnabled {
                    let textLayer = PhotoEditingObservationDebugLayer(fillColor: .systemRed, frame: bounds, shape: textObservation.bounds)

                    return characterLayers + [textLayer]
                } else { return characterLayers }
            }

            let calculator = PhotoEditingObservationCalculator(
                detectedCharacterObservations: textObservations.flatMap(\.characterObservations),
                recognizedCharacterObservations: recognizedTextObservations.flatMap(\.characterObservations)
            )
            let calculatedObservations = await calculator.calculatedObservationsByUUID

            let wordCharacterLayers: [PhotoEditingObservationDebugLayer]
            if isCalculatedOverlayEnabled {
                wordCharacterLayers = calculatedObservations.flatMap(\.value).map { (calculatedObservation: CharacterObservation) -> PhotoEditingObservationDebugLayer in
                    PhotoEditingObservationDebugLayer(fillColor: .systemGreen, frame: bounds, shape: calculatedObservation.bounds)
                }
            } else { wordCharacterLayers = [] }

            let combinedLayers: [PhotoEditingObservationDebugLayer]
            if isCombinedOverlayEnabled {
                combinedLayers = calculatedObservations.map { (_, observations) in
                    PhotoEditingObservationDebugLayer(fillColor: .systemPurple, frame: bounds, shape: MinimumAreaShapeFinder.minimumAreaShape(for: observations.map(\.bounds)))
                }
            } else { combinedLayers = [] }

            return textLayers + wordLayers + wordCharacterLayers + combinedLayers
        }
    }
}

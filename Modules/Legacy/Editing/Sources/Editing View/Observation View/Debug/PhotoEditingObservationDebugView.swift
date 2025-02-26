//  Created by Geoff Pado on 7/8/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

@_implementationOnly import ClippingBezier
import Combine
import Defaults
import FeatureFlags
import Geometry
import Observations
import UIKit

class PhotoEditingObservationDebugView: PhotoEditingRedactionView {
    private let flagProvider: any FeatureFlagProvider
    init(
        flagProvider: any FeatureFlagProvider = FeatureFlags.provider
    ) {
        self.flagProvider = flagProvider
        super.init()
        isUserInteractionEnabled = false
        subscribeToUpdates()
    }

    deinit {
        _ = cancellables.map(NotificationCenter.default.removeObserver(_:))
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

    @Defaults.Value(key: .showDetectedTextOverlay) private var isDetectedTextOverlayEnabled: Bool
    @Defaults.Value(key: .showDetectedCharactersOverlay) private var isDetectedCharactersOverlayEnabled: Bool
    @Defaults.Value(key: .showRecognizedTextOverlay) private var isRecognizedTextOverlayEnabled: Bool
    @Defaults.Value(key: .showCalculatedOverlay) private var isCalculatedOverlayEnabled: Bool
    @Defaults.Value(key: .showCombinedOverlay) private var isCombinedOverlayEnabled: Bool
    private var cancellables = [any NSObjectProtocol]()

    private func subscribeToUpdates() {
        let update: @MainActor @Sendable () -> Void = { [weak self] in self?.updateDebugLayers() }
        cancellables.append(NotificationCenter.default.addObserver(for: _isDetectedTextOverlayEnabled, block: update))
        cancellables.append(NotificationCenter.default.addObserver(for: _isDetectedCharactersOverlayEnabled, block: update))
        cancellables.append(NotificationCenter.default.addObserver(for: _isRecognizedTextOverlayEnabled, block: update))
        cancellables.append(NotificationCenter.default.addObserver(for: _isCalculatedOverlayEnabled, block: update))
        cancellables.append(NotificationCenter.default.addObserver(for: _isCombinedOverlayEnabled, block: update))
    }

    private func updateDebugLayers() {
        Task {
            layer.sublayers = await debugLayers
        }
    }

    // MARK: Debug Layers

    private var debugLayers: [CAShapeLayer] {
        get async {
            guard flagProvider.shouldShowDebugOverlay, let textObservations, let recognizedTextObservations else { return [] }

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

                if Defaults.Value(key: .showDetectedTextOverlay).wrappedValue {
                    let textLayer = PhotoEditingObservationDebugLayer(fillColor: .systemRed, frame: bounds, shape: textObservation.bounds)

                    return characterLayers + [textLayer]
                } else { return characterLayers }
            }

            let calculator = PhotoEditingObservationCalculator(detectedTextObservations: textObservations, recognizedTextObservations: recognizedTextObservations)
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

//  Created by Geoff Pado on 7/8/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

@_implementationOnly import ClippingBezier
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

    var recognizedTextObservations: [RecognizedTextObservation]? {
        didSet {
            updateDebugLayers()
            setNeedsDisplay()
        }
    }

    private func updateDebugLayers() {
        layer.sublayers = debugLayers
    }

    private var debugLayers: [CAShapeLayer] {
        guard FeatureFlag.shouldShowDebugOverlay, let textObservations, let recognizedTextObservations else { return [] }

        // find words (new system)
        let wordLayers = recognizedTextObservations.map { wordObservation in
            let outlineLayer = CAShapeLayer()
            outlineLayer.fillColor = UIColor.systemGreen.withAlphaComponent(0.3).cgColor
            outlineLayer.frame = bounds
            outlineLayer.path = wordObservation.path
            return outlineLayer
        }

        // find text (old system)
        let textLayers = textObservations.flatMap { textObservation -> [CAShapeLayer] in
            let characterObservations = textObservation.characterObservations
            let characterLayers = characterObservations.map { observation -> CAShapeLayer in
                let layer = CAShapeLayer()
                layer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
                layer.frame = bounds
                layer.path = observation.bounds.path
                return layer
            }

            let textLayer = CAShapeLayer()
            textLayer.fillColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor
            textLayer.frame = bounds
            textLayer.path = CGPath(rect: textObservation.bounds.boundingBox, transform: nil)

            return characterLayers + [textLayer]
        }

        let filteredTextLayers = textLayers.filter { textLayer in
            guard let textCGPath = textLayer.path else { return false }
            let textPath = UIBezierPath(cgPath: textCGPath)

            let hasIntersection = wordLayers.contains { wordLayer in
                guard let wordCGPath = wordLayer.path else { return false }
                let wordPath = UIBezierPath(cgPath: wordCGPath)

                let isEqual = textCGPath.isEqual(to: wordCGPath, accuracy: 0.01)
                guard isEqual == false else { return true }

                let isContained = textPath.contains(wordPath.currentPoint) || wordPath.contains(textPath.currentPoint)
                guard isContained == false else { return true }

                let intersections = textPath.intersection(with: wordPath)
                guard intersections?.count ?? 0 == 0 else { return true }

                let inverseIntersections = wordPath.intersection(with: textPath)
                guard inverseIntersections?.count ?? 0 == 0 else { return true }

                return false
            }
            return !hasIntersection
        }

        let characterObservations = recognizedTextObservations.flatMap(\.characterObservations)
        let characterObservationSet = Set(characterObservations)
        let wordCharacterLayers = characterObservationSet.map { (characterObservation: CharacterObservation) -> CAShapeLayer in
            let textLayer = CAShapeLayer()
            textLayer.fillColor = UIColor.systemYellow.withAlphaComponent(0.3).cgColor
            textLayer.frame = bounds
            textLayer.path = characterObservation.bounds.path
            return textLayer
        }

        return textLayers + wordLayers + wordCharacterLayers
    }
}

extension CGPath {
    func svg(color: String) -> String {
        var string = ""
        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            let elementType = element.type
            switch elementType {
            case .moveToPoint:
                string.append("M ")
                let elementPoint = element.points.pointee
                string.append("\(elementPoint.x),\(elementPoint.y)")
                string.append("\n")
            case .addLineToPoint:
                string.append("L ")
                let elementPoint = element.points.pointee
                string.append("\(elementPoint.x),\(elementPoint.y)")
                string.append("\n")
            case .addCurveToPoint:
                string.append("C ")
                string.append("\n")
                // TODO: Implement me!
            case .addQuadCurveToPoint:
                string.append("Q ")
                string.append("\n")
                // TODO: Implement me!
            case .closeSubpath:
                string.append("Z\n")
            @unknown default: break
            }
        }
        return "<path d=\"\(string)\" fill=\"\(color)\" fill-opacity=\"0.3\"/>"
    }
}

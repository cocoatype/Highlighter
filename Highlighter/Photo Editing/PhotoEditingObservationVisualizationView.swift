//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingObservationVisualizationView: UIView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let textObservations = textObservations else { return }

        textObservations.forEach { observation in
            UIColor.red.withAlphaComponent(0.3).setFill()
            UIColor.red.setStroke()

            let boundsPath = UIBezierPath(rect: observation.bounds)
            boundsPath.fill()
            boundsPath.stroke()

            observation.characterObservations?.forEach { characterObservation in
                let isRedacted = redactedCharacterObservations?.contains(characterObservation) ?? false
                let baseColor = isRedacted ? UIColor.green : UIColor.blue
                baseColor.withAlphaComponent(0.3).setFill()
                baseColor.setStroke()

                let boundsPath = UIBezierPath(rect: characterObservation.bounds)
                boundsPath.fill()
                boundsPath.stroke()
            }
        }
    }

    var textObservations: [DetectedTextObservation]? {
        didSet {
            setNeedsDisplay()
        }
    }

    #warning("Do not merge; only for temporary debugging purposes")
    var redactedCharacterObservations: [DetectedCharacterObservation]? {
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

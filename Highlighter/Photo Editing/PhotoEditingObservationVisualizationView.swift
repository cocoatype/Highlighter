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

            UIColor.blue.withAlphaComponent(0.3).setFill()
            UIColor.blue.setStroke()

            observation.characterObservations?.forEach { characterObservation in
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

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

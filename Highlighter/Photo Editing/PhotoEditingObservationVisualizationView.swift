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

//  Created by Geoff Pado on 5/6/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingRedactionView: UIView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIColor.green.setStroke()

        redactions
          .flatMap { $0.paths }
          .map { $0.dashedPath }
          .forEach { path in
            let brushStampImage = brushStamp(scaledToHeight: path.lineWidth)
            path.forEachPoint{ point in
                guard let context = UIGraphicsGetCurrentContext() else { return }
                context.saveGState()
                defer { context.restoreGState() }

                context.translateBy(x: brushStampImage.size.width * -0.5, y: brushStampImage.size.height * -0.5)
                brushStampImage.draw(at: point)
            }
        }
    }

    func add(_ redaction: Redaction) {
        redactions.append(redaction)
        setNeedsDisplay()
    }

    private func brushStamp(scaledToHeight height: CGFloat) -> UIImage {
        guard let standardImage = UIImage(named: "Brush") else { fatalError("Unable to load brush stamp image") }

        let brushScale = height / standardImage.size.height
        let scaledBrushSize = standardImage.size * brushScale

        UIGraphicsBeginImageContext(scaledBrushSize)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { fatalError("Unable to create brush scaling image context") }
        context.scaleBy(x: brushScale, y: brushScale)

        standardImage.draw(at: .zero)

        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError("Unable to get scaled brush image from context") }
        return scaledImage
    }

    // MARK: Boilerplate

    private var redactions = [Redaction]()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

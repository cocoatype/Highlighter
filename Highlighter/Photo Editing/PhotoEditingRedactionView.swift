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
        redactions.forEach { redaction in
            let path = redaction.path
            path.lineWidth = 10.0
            path.stroke()
        }
    }

    func add(_ redaction: Redaction) {
        redactions.append(redaction)
        setNeedsDisplay(redaction.path.bounds)
    }

    // MARK: Boilerplate

    private var redactions = [Redaction]()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

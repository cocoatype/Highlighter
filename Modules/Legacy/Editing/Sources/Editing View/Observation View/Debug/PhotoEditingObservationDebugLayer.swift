//  Created by Geoff Pado on 6/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Geometry
import UIKit

class PhotoEditingObservationDebugLayer: CAShapeLayer {
    init(fillColor: UIColor, frame: CGRect, shape: Shape) {
        super.init()
        self.strokeColor = fillColor.cgColor
        self.fillColor = fillColor.withAlphaComponent(0.3).cgColor
        self.frame = frame
        self.path = shape.path
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

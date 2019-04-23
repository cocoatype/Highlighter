//  Created by Geoff Pado on 4/22/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import Vision

struct DetectedTextObservation {
    init(_ textObservation: VNTextObservation, in image: UIImage) {
        var boundingBox = textObservation.boundingBox
        boundingBox.origin.y = (1.0 - boundingBox.origin.y)

        let imageSize = image.size * image.scale
        boundingBox.origin.x *= imageSize.width
        boundingBox.origin.y *= imageSize.height
        boundingBox.size.width *= imageSize.width
        boundingBox.size.height *= imageSize.height
        boundingBox.origin.y -= boundingBox.size.height

        self.bounds = boundingBox.integral
    }

    let bounds: CGRect
}

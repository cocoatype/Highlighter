//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoExporter: NSObject {
    init(image: UIImage, redactions: [Redaction]) {
        let imageSize = image.size * image.scale
        let bounds = CGRect(origin: .zero, size: imageSize)

        imageView.frame = bounds
        redactionView.frame = bounds

        imageView.image = image
        redactionView.add(redactions)
    }

    var exportedImage: UIImage? {
        let imageBounds = imageView.bounds
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 1)
        defer { UIGraphicsEndImageContext() }

        imageView.drawHierarchy(in: imageBounds, afterScreenUpdates: true)
        redactionView.drawHierarchy(in: imageBounds, afterScreenUpdates: true)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    // MARK: Boilerplate

    private let imageView = PhotoEditingImageView()
    private let redactionView = PhotoEditingRedactionView()
}

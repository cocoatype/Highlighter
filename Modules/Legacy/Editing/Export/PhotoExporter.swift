//  Created by Geoff Pado on 5/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoExporter: NSObject {
    static func export(_ image: UIImage, redactions: [Redaction]) async throws -> UIImage {
        return try await PhotoExportRenderer(image: image, redactions: redactions).render()
    }
}

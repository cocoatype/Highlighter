//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import ImageIO
import UIKit

import Redactions

public protocol PhotoRenderer: Sendable {
    func render(image: UIImage, redactions: [Redaction]) async throws -> UIImage
    func render(imageSource: CGImageSource, redactions: [Redaction]) async throws -> CGImage
}

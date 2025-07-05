//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import RedactionsMac
public typealias PhotoRendererImage = NSImage
#elseif canImport(UIKit)
import UIKit
import Redactions
public typealias PhotoRendererImage = UIImage
#endif

import ImageIO

public protocol PhotoRenderer: Sendable {
    func render(image: PhotoRendererImage, redactions: [Redaction]) async throws -> PhotoRendererImage
    func render(imageSource: CGImageSource, redactions: [Redaction]) async throws -> CGImage
}

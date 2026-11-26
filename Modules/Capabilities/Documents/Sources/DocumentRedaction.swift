//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import CoreGraphics

/// A temporary stand-in for `Redaction`, which doesn't build on native macOS
/// yet (#590). Replace it with `Redaction` in #673.
public struct DocumentRedaction: Equatable, Sendable {
    /// The redacted areas, in image coordinates.
    public let rects: [CGRect]

    public init(rects: [CGRect]) {
        self.rects = rects
    }
}
#endif

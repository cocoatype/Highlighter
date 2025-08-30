//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation
import Testing

@testable import Geometry

struct CGImageExtensionsTests {
    @Test func size() throws {
        let context = try #require(CGContext(
            data: nil,
            width: 16,
            height: 9,
            bitsPerComponent: 8,
            bytesPerRow: 64,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        let image = try #require(context.makeImage())
        #expect(image.size == CGSize(width: 16, height: 9))
    }
}

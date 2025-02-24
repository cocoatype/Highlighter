//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Testing

@testable import Tools

struct CGSizeExtensionsTests {
    @Test func initWithDimension() {
        #expect(CGSize(dimension: 20) == CGSize(width: 20, height: 20))
    }
}

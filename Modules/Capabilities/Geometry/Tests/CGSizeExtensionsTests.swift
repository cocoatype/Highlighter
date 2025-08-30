//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation
import Testing

@testable import Geometry

struct CGSizeExtensionsTests {
    @Test func multiplyByFloat() {
        let size = CGSize(width: 10, height: 20)
        #expect(size * 2.5 == CGSize(width: 25, height: 50))
    }

    @Test func integral() {
        let size = CGSize(width: 10.5, height: 20.25)
        #expect(size.integral == CGSize(width: 10, height: 20))
    }
}

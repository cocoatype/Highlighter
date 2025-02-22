//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import Tools

struct DoubleExtensionsTests {
    @Test func multiplyDoubleByInt() {
        #expect(Double(4) * Int(2) == 8.0)
    }

    @Test func multiplyIntByDouble() {
        #expect(Int(4) * Double(2) == 8.0)
    }
}

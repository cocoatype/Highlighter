//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import FeatureFlagging

struct OptionalStringExtensionsTests {
    @Test(arguments: [
        (nil, false),
        ("", false),
        ("0", false),
        ("1", true),
        ("false", false),
        ("true", true),
        ("YES", true),
        ("NO", false),
        ("yes", true),
        ("no", false),
        ("hello world", true),
    ])
    func isTruthy(value: String?, expected: Bool) {
        #expect(value.isTruthy == expected)
    }
}

//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Testing
import UIKit

@testable import IntroView

@MainActor
struct IntroLabelTests {
    @Test func body() throws {
        let label = IntroLabel("Text")
        #expect(label.text == "Text")
        #expect(label.textColor == .primaryExtraLight)
        #expect(label.font == .appFont(forTextStyle: .body))
        #expect(label.numberOfLines == 0)
    }
}

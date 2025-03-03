//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Testing
import ViewInspector

@testable import IntroView

@MainActor
struct IntroLabelTests {
    @Test func body() throws {
        let label = try IntroLabel("Text").inspect()
        let text = try label.find(text: "Text")
        let color = try #require(try text.attributes().foregroundColor())
        #expect(color == .primaryExtraLight)

        let font = try text.attributes().font()
        #expect(font == .app(textStyle: .body))
    }
}

//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Testing
import ViewInspector

@testable import IntroView

@MainActor
struct IntroButtonTests {
    @Test
    func title() throws {
        let button = try IntroButton("Title", action: {}).inspect()
        let text = try button.find(text: "Title")
        let attributes = try text.attributes()
        let color = try #require(try attributes.foregroundColor())
        #expect(color == .white)

        let font = try attributes.font()
        #expect(font == .app(textStyle: .headline))

        let isUnderline = try attributes.isUnderline()
        #expect(isUnderline)
    }

    @Test
    func action() async throws {
        try await confirmation { buttonTapped in
            let button = try IntroButton("Title", action: {
                buttonTapped()
            }).inspect()
            let internalButton = try button.find(button: "Title")
            try internalButton.tap()
        }
    }
}

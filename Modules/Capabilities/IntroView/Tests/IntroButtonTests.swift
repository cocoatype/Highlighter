//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Testing
import UIKit

@testable import IntroView

@MainActor
struct IntroButtonTests {
    @Test
    func title() throws {
        let button = IntroButton("Title", action: {})
        let attributedTitle = try #require(button.titleLabel?.attributedText)
        #expect(attributedTitle.string == "Title")

        let attributes = attributedTitle.attributes(at: 0, effectiveRange: nil)
        #expect(attributes[.foregroundColor] as? UIColor == .white)
        #expect(attributes[.font] as? UIFont == .appFont(forTextStyle: .headline))
        #expect(attributes[.underlineStyle] as? Int == NSUnderlineStyle.single.rawValue)
    }

    @Test
    func action() async throws {
        await confirmation { buttonTapped in
            let button = IntroButton("Title", action: {
                buttonTapped()
            })
            button.sendActions(for: .primaryActionTriggered)
        }
    }
}

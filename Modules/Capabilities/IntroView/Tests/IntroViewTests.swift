//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import DesignSystem
import Testing
import UIKit

@testable import IntroView

@MainActor
struct IntroViewTests {
    @Test
    func permissionLabel() throws {
        let introView = IntroView()
        #expect(introView.permissionLabel.text == Strings.IntroView.permissionLabelText)
    }

    @Test
    func permissionButton() async throws {
        await confirmation { buttonTapped in
            let introView = IntroView(
                permissionAction: { buttonTapped() }
            )
            #expect(introView.permissionButton.title == Strings.IntroView.permissionButtonTitle)
            introView.permissionButton.sendActions(for: .primaryActionTriggered)
        }
    }

    @Test
    func importLabel() throws {
        let introView = IntroView()
        #expect(introView.importLabel.text == Strings.IntroView.importLabelText)
    }

    @Test
    func importButton() async throws {
        await confirmation { buttonTapped in
            let introView = IntroView(
                importAction: { buttonTapped() }
            )
            #expect(introView.importButton.title == Strings.IntroView.importButtonTitle)
            introView.importButton.sendActions(for: .primaryActionTriggered)
        }
    }

    @Test
    func order() {
        let introView = IntroView()
        #expect(introView.stackView.arrangedSubviews == [
            introView.permissionLabel,
            introView.permissionButton,
            introView.importLabel,
            introView.importButton,
        ])
        #expect(introView.stackView.spacing == 3)
        #expect(introView.stackView.customSpacing(after: introView.permissionButton) == 15)
    }

    @Test
    func maximumWidth() throws {
        let introView = IntroView()
        introView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        introView.layoutIfNeeded()
        #expect(introView.stackView.frame.width <= 240)
        #expect(introView.stackView.frame.width > 0)
        #expect(abs(introView.stackView.center.x - introView.bounds.midX) < 1)
    }

    @Test
    func background() {
        #expect(IntroView().backgroundColor == .primary)
    }
}

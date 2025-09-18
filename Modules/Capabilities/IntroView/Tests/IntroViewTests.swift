//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI
import Testing
import ViewInspector

@testable import IntroView

@MainActor
struct IntroViewTests {
    @Test
    func permissionLabel() throws {
        let introView = try IntroView().inspect()
        _ = try introView.find(IntroLabel.self, containing: Strings.IntroView.permissionLabelText)
    }

    @Test
    func permissionButton() async throws {
        try await confirmation { buttonTapped in
            let introView = try IntroView(
                permissionAction: { buttonTapped() }
            ).inspect()
            let button = try introView.find(IntroButton.self, containing: Strings.IntroView.permissionButtonTitle)
            let internalButton = try button.find(button: Strings.IntroView.permissionButtonTitle)
            try internalButton.tap()
        }
    }

    @Test
    func importLabel() throws {
        let introView = try IntroView().inspect()
        _ = try introView.find(IntroLabel.self, containing: Strings.IntroView.importLabelText)
    }

    @Test
    func importButton() async throws {
        try await confirmation { buttonTapped in
            let introView = try IntroView(
                importAction: { buttonTapped() }
            ).inspect()
            let button = try introView.find(IntroButton.self, containing: Strings.IntroView.importButtonTitle)
            let internalButton = try button.find(button: Strings.IntroView.importButtonTitle)
            try internalButton.tap()
        }
    }

    @Test
    func vStack() throws {
        let introView = try IntroView().inspect()
        let vStack = try introView.find(ViewType.VStack.self)
        let (_, _, maxWidth, _, _, _, _) = try vStack.flexFrame()
        #expect(maxWidth == 240)
    }
}

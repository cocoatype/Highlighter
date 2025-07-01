//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Testing

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import DesignSystem

@testable import Unpurchased

@MainActor @Suite(.container)
struct UnpurchasedAlertControllerFactoryTests {
    @Test func alertControllerHasCorrectTint() {
        let feature = UnpurchasedFeature(message: "", learnMoreAction: nil, hideFeatureKey: nil)
        let factory = UnpurchasedAlertControllerFactory()
        let alert = factory.alertController(for: feature)

        #expect(alert.view.tintColor == .controlTint)
    }

    @Test func alertControllerSetsMessage() {
        let feature = UnpurchasedFeature(message: "Hello, world!", learnMoreAction: nil, hideFeatureKey: nil)
        let factory = UnpurchasedAlertControllerFactory()
        let alert = factory.alertController(for: feature)

        #expect(alert.message == feature.message)
    }

    @Test func alertControllerHasCancelAction() throws {
        let feature = UnpurchasedFeature(message: "", learnMoreAction: nil, hideFeatureKey: nil)
        let factory = UnpurchasedAlertControllerFactory()
        let alert = factory.alertController(for: feature)

        #expect(alert.actions.count == 1)
        let cancelAction = try #require(alert.actions.first)
        #expect(cancelAction.title == UnpurchasedStrings.UnpurchasedAlert.dismissButton)
        #expect(cancelAction.style == .cancel)

        // just for code coverage
        let handler = try #require((cancelAction as? UnpurchasedAlertAction)?.action)
        handler()
    }

    @Test func alertControllerAddsActionForLearnMore() async throws {
        try await confirmation { learnMoreActionCalled in
            let feature = UnpurchasedFeature(
                message: "",
                learnMoreAction: { learnMoreActionCalled() },
                hideFeatureKey: nil
            )
            let factory = UnpurchasedAlertControllerFactory()
            let alert = factory.alertController(for: feature)

            #expect(alert.actions.count == 2)
            let learnMoreAction = try #require(alert.actions.first)
            #expect(learnMoreAction.title == UnpurchasedStrings.UnpurchasedAlert.learnMoreButton)
            #expect(learnMoreAction.style == .default)
            let handler = try #require((learnMoreAction as? UnpurchasedAlertAction)?.action)
            handler()
        }
    }

    @Test func alertControllerAddsActionForHideFeature() throws {
        let key = Keys.hideAutoRedactions
        let feature = UnpurchasedFeature(
            message: "",
            learnMoreAction: nil,
            hideFeatureKey: key
        )
        let defaults = StubDefaultsProvider()
        Container.shared.defaults.register { defaults }
        let factory = UnpurchasedAlertControllerFactory()
        let alert = factory.alertController(for: feature)

        #expect(alert.actions.count == 2)
        let hideAction = try #require(alert.actions.first)
        #expect(hideAction.title == UnpurchasedStrings.UnpurchasedAlert.hideButton)
        #expect(hideAction.style == .default)
        let handler = try #require((hideAction as? UnpurchasedAlertAction)?.action)
        handler()
        #expect(defaults.value(for: key) == true)
    }
}

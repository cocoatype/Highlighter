//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import Purchasing
import PurchasingDoubles

@testable import MobileSettingsUI

@MainActor @Suite(.container)
struct SettingsViewControllerTests {
    @Test func hostingControllerShowsSettingsInFormSheet() throws {
        Container.shared.purchaseRepository.register { SpyRepository() }
        let hostingController = SettingsHostingController()
        let settingsViewController = try #require(hostingController.viewControllers.first as? SettingsViewController)
        #expect(hostingController.modalPresentationStyle == .formSheet)
        #expect(settingsViewController.preferredContentSize == CGSize(width: 640, height: 640))
    }

    @Test func closeButtonIsWiredImmediately() throws {
        Container.shared.purchaseRepository.register { SpyRepository() }
        let viewController = SettingsViewController()
        let closeButton = try #require(viewController.navigationItem.rightBarButtonItem)
        #expect(closeButton.action == #selector(SettingsHostingControllerActions.dismissSettingsViewController))
        #expect(closeButton.accessibilityLabel == Strings.DoneButton.label)
    }

    @Test func usesCachedPurchaseStateImmediately() {
        Container.shared.purchaseRepository.register { SpyRepository(withCheese: .purchased) }
        let viewController = SettingsViewController()
        viewController.loadViewIfNeeded()
        #expect(viewController.model.sections[0].rows.map(\.action) == [.pushAutoRedactions])
    }

    @Test func hidingAutoRedactionsRemovesRow() {
        let defaults = StubDefaultsProvider()
        Container.shared.defaults.register { defaults }
        Container.shared.purchaseRepository.register { SpyRepository(withCheese: .loading) }

        let viewController = SettingsViewController()
        viewController.loadViewIfNeeded()
        #expect(viewController.model.row(withID: "autoRedactionsAlert") != nil)

        defaults.set(true, for: Keys.hideAutoRedactions)
        viewController.applyModel(animated: false)
        #expect(viewController.model.row(withID: "autoRedactionsAlert") == nil)
    }
}

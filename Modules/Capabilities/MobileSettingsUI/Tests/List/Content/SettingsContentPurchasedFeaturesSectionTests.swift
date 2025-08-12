//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AutoRedactionsUI
import Paywall
import ViewInspector
import XCTest

@testable import MobileSettingsUI

@MainActor @available(iOS 16.0, *)
class SettingsContentPurchasedFeaturesSectionTests: XCTestCase {
    func testContainsPurchaseNavigationLinkIfNotPurchased() throws {
        let section = try SettingsContentPurchasedFeaturesSection(
            state: .loading
        ).inspect().find(SettingsContentPurchasedFeaturesSection.self)

        XCTAssertNoThrow(try section.find(PurchaseNavigationLink.self))
    }

    func testDoesNotContainSettingsNavigationLinkIfNotPurchased() throws {
        let section = try SettingsContentPurchasedFeaturesSection(
            state: .loading
        ).inspect().find(SettingsContentPurchasedFeaturesSection.self)

        XCTAssertThrowsError(try section.find(SettingsNavigationLink<AutoRedactionsEditView>.self))
    }

    func testDoesNotContainPurchaseNavigationLinkIfPurchased() throws {
        let section = try SettingsContentPurchasedFeaturesSection(
            state: .purchased
        ).inspect().find(SettingsContentPurchasedFeaturesSection.self)

        XCTAssertThrowsError(try section.find(PurchaseNavigationLink.self))
    }

    func testContainsSettingsNavigationLinkIfPurchased() throws {
        let section = try SettingsContentPurchasedFeaturesSection(
            state: .purchased
        ).inspect().find(SettingsContentPurchasedFeaturesSection.self)

        XCTAssertNoThrow(try section.find(SettingsNavigationLink<AutoRedactionsEditView>.self))
    }
}

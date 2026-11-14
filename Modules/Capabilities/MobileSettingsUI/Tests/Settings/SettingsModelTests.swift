//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

import Purchasing
import PurchasingDoubles

@testable import MobileSettingsUI

struct SettingsModelTests {
    private func model(
        purchaseState: PurchaseState = .loading,
        hideAutoRedactions: Bool = false,
        infoDictionary: [String: Any]? = ["CFBundleShortVersionString": "89.0"],
        isPaywallAvailable: Bool = true
    ) -> SettingsModel {
        SettingsModel(
            purchaseState: purchaseState,
            hideAutoRedactions: hideAutoRedactions,
            infoDictionary: infoDictionary,
            isPaywallAvailable: isPaywallAvailable
        )
    }

    private func purchasedFeatureActions(_ model: SettingsModel) -> [SettingsModel.Action] {
        model.sections[0].rows.map(\.action)
    }

    // MARK: Sections

    @Test func sectionsInOrder() {
        let model = model()
        #expect(model.sections.map(\.id) == [.purchasedFeatures, .information, .contact, .otherApps])
        #expect(model.sections[0].header == nil)
        #expect(model.sections[1].header == Strings.SettingsContentInformationSection.header)
        #expect(model.sections[2].header == Strings.SettingsContentContactSection.header)
        #expect(model.sections[3].header == Strings.SettingsContentOtherAppsSection.header)
    }

    // MARK: Information

    @Test func versionSubtitle() {
        let releaseNotes = model().sections[1].rows[0]
        #expect(releaseNotes.title == Strings.SettingsContentInformationSection.releaseNotesTitle)
        #expect(releaseNotes.subtitle == "Version 89.0")
        #expect(releaseNotes.action == .web(URL(string: "https://blackhighlighter.app/releases")!))
    }

    @Test func versionSubtitleFallback() {
        #expect(model(infoDictionary: [:]).sections[1].rows[0].subtitle == "Version ???")
        #expect(model(infoDictionary: nil).sections[1].rows[0].subtitle == "Version ???")
    }

    @Test func informationRows() {
        let rows = model().sections[1].rows
        #expect(rows.map(\.action) == ["releases", "about", "privacy", "acknowledgements"].map {
            .web(URL(string: "https://blackhighlighter.app/\($0)")!)
        })
    }

    // MARK: Purchased Features

    @Test(arguments: [PurchaseState.loading, .unavailable, .readyForPurchase(products: []), .purchasing, .restoring])
    func notPurchasedShowsPaywallAndAlert(purchaseState: PurchaseState) {
        #expect(purchasedFeatureActions(model(purchaseState: purchaseState)) == [.pushPaywall, .showUnpurchasedAlert])
    }

    @Test func notPurchasedWithHiddenAutoRedactionsShowsOnlyPaywall() {
        #expect(purchasedFeatureActions(model(hideAutoRedactions: true)) == [.pushPaywall])
    }

    @Test func purchasedShowsAutoRedactions() {
        let rows = model(purchaseState: .purchased, hideAutoRedactions: true).sections[0].rows
        #expect(rows.map(\.action) == [.pushAutoRedactions])
        #expect(rows[0].title == Strings.SettingsContentPurchasedFeaturesSection.autoRedactionsTitle)
        #expect(rows[0].showsDisclosureIndicator)
    }

    @Test func paywallRowRequiresPaywallAvailability() {
        #expect(purchasedFeatureActions(model(isPaywallAvailable: false)) == [.showUnpurchasedAlert])
    }

    @Test func purchaseRowStyle() throws {
        let row = try #require(model().row(withID: "purchase"))
        #expect(row.style == .purchase)
        #expect(row.title == Strings.PurchaseItem.title)
        #expect(row.showsDisclosureIndicator)
    }

    // MARK: Purchase Subtitle

    @Test func purchaseSubtitleWithoutProducts() {
        #expect(SettingsModel.purchaseSubtitle(for: .loading) == Strings.PurchaseSubtitle.withoutProduct)
        #expect(SettingsModel.purchaseSubtitle(for: .readyForPurchase(products: [])) == Strings.PurchaseSubtitle.withoutProduct)
    }

    @Test func purchaseSubtitlePrefersAnnual() {
        let monthly = StubProduct(price: 0.99, duration: .monthly)
        let annual = StubProduct(price: 4.99, duration: .annual)
        let subtitle = SettingsModel.purchaseSubtitle(for: .readyForPurchase(products: [monthly, annual]))
        #expect(subtitle == Strings.PurchaseSubtitle.withProduct(annual.displayPrice + Strings.PurchaseSubtitle.annual))
    }

    @Test func purchaseSubtitleFallsBackToFirstProduct() {
        let monthly = StubProduct(price: 0.99, duration: .monthly)
        let subtitle = SettingsModel.purchaseSubtitle(for: .readyForPurchase(products: [monthly]))
        #expect(subtitle == Strings.PurchaseSubtitle.withProduct(monthly.displayPrice + Strings.PurchaseSubtitle.monthly))
    }

    // MARK: Contact and Other Apps

    @Test func contactRows() {
        let rows = model().sections[2].rows
        #expect(rows.map(\.id) == ["mail", "review", "bluesky", "facebook", "threads", "x"])
        #expect(rows[0].action == .mail)
        #expect(rows[1].action == .openURL(SettingsModel.reviewURL))
        #expect(rows[2].action == .web(URL(string: "https://blackhighlighter.app/contact/bluesky")!))
        #expect(rows.allSatisfy { $0.iconName != nil })
    }

    @Test func otherAppRows() {
        let rows = model().sections[3].rows
        #expect(rows.map(\.title) == ["Barc", "Kineo", "Debigulator"])
        #expect(rows[0].action == .openURL(URL(string: "https://apps.apple.com/us/app/cocoatype/id6642707689?uo=4")!))
        #expect(rows.allSatisfy { $0.showsDisclosureIndicator == false })
    }
}

//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

import ErrorHandling
import Purchasing

/// The contents of the settings list, built from purchase state and app info.
struct SettingsModel: Equatable {
    struct Section: Hashable {
        let id: SectionID
        let header: String?
        let rows: [Row]
    }

    enum SectionID: Hashable {
        case purchasedFeatures
        case information
        case contact
        case otherApps
    }

    enum RowStyle: Hashable {
        /// A regular row: subheadline title, footnote subtitle.
        case standard
        /// The Ultra Highlighter purchase row: title3 title, subheadline subtitle.
        case purchase
    }

    struct Row: Hashable {
        let id: String
        let title: String
        var subtitle: String?
        var iconName: String?
        var style = RowStyle.standard
        let action: Action

        var showsDisclosureIndicator: Bool {
            switch action {
            case .pushPaywall, .pushAutoRedactions: true
            case .showUnpurchasedAlert, .web, .mail, .openURL: false
            }
        }
    }

    enum Action: Hashable {
        case pushPaywall
        case pushAutoRedactions
        case showUnpurchasedAlert
        case web(URL)
        case mail
        case openURL(URL)
    }

    let sections: [Section]

    init(
        purchaseState: PurchaseState,
        hideAutoRedactions: Bool,
        infoDictionary: [String: Any]? = Bundle.main.infoDictionary,
        isPaywallAvailable: Bool = SettingsModel.isPaywallAvailable
    ) {
        sections = [
            Self.purchasedFeaturesSection(purchaseState: purchaseState, hideAutoRedactions: hideAutoRedactions, isPaywallAvailable: isPaywallAvailable),
            Self.informationSection(infoDictionary: infoDictionary),
            Self.contactSection,
            Self.otherAppsSection,
        ]
    }

    static var isPaywallAvailable: Bool {
        if #available(iOS 16.0, *) { true } else { false }
    }

    func row(withID id: String) -> Row? {
        sections.lazy.flatMap(\.rows).first { $0.id == id }
    }

    // MARK: Purchased Features

    private static func purchasedFeaturesSection(purchaseState: PurchaseState, hideAutoRedactions: Bool, isPaywallAvailable: Bool) -> Section {
        typealias Strings = MobileSettingsUI.Strings.SettingsContentPurchasedFeaturesSection
        var rows = [Row]()

        if purchaseState == .purchased {
            rows.append(Row(id: "autoRedactions", title: Strings.autoRedactionsTitle, action: .pushAutoRedactions))
        } else {
            if isPaywallAvailable {
                rows.append(Row(
                    id: "purchase",
                    title: MobileSettingsUI.Strings.PurchaseItem.title,
                    subtitle: purchaseSubtitle(for: purchaseState),
                    style: .purchase,
                    action: .pushPaywall
                ))
            }

            if hideAutoRedactions == false {
                rows.append(Row(id: "autoRedactionsAlert", title: Strings.autoRedactionsTitle, action: .showUnpurchasedAlert))
            }
        }

        return Section(id: .purchasedFeatures, header: nil, rows: rows)
    }

    static func purchaseSubtitle(for purchaseState: PurchaseState) -> String {
        typealias Strings = MobileSettingsUI.Strings.PurchaseSubtitle
        guard let products = purchaseState.products,
              let selectedProduct = products.first(where: { $0.duration == .annual }) ?? products.first
        else { return Strings.withoutProduct }

        let addendum = switch selectedProduct.duration {
        case .monthly: Strings.monthly
        case .annual: Strings.annual
        case .oneTime: Strings.oneTime
        case .unknown: Strings.unknown
        }
        return Strings.withProduct(selectedProduct.displayPrice + addendum)
    }

    // MARK: Information

    private static func informationSection(infoDictionary: [String: Any]?) -> Section {
        typealias Strings = MobileSettingsUI.Strings.SettingsContentInformationSection
        let versionString = infoDictionary?["CFBundleShortVersionString"] as? String ?? "???"

        return Section(id: .information, header: Strings.header, rows: [
            Row(id: "releaseNotes", title: Strings.releaseNotesTitle, subtitle: Strings.versionStringFormat(versionString), action: .web(URL(websitePath: "releases"))),
            Row(id: "about", title: Strings.aboutTitle, action: .web(URL(websitePath: "about"))),
            Row(id: "privacy", title: Strings.privacyTitle, action: .web(URL(websitePath: "privacy"))),
            Row(id: "acknowledgements", title: Strings.acknowledgementsTitle, action: .web(URL(websitePath: "acknowledgements"))),
        ])
    }

    // MARK: Contact

    static let reviewURL = URL(staticString: "https://itunes.apple.com/us/app/appName/id1215283742?mt=8&action=write-review")

    private static var contactSection: Section {
        typealias Strings = MobileSettingsUI.Strings.SettingsContentContactSection

        return Section(id: .contact, header: Strings.header, rows: [
            Row(id: "mail", title: Strings.emailTitle, subtitle: Strings.emailSubtitle, iconName: MobileSettingsUIAsset.mail.name, action: .mail),
            Row(id: "review", title: Strings.appStoreTitle, subtitle: Strings.appStoreSubtitle, iconName: MobileSettingsUIAsset.appStore.name, action: .openURL(reviewURL)),
            Row(id: "bluesky", title: Strings.blueskyTitle, subtitle: Strings.blueskySubtitle, iconName: MobileSettingsUIAsset.bluesky.name, action: .web(URL(websitePath: "contact/bluesky"))),
            Row(id: "facebook", title: Strings.facebookTitle, subtitle: Strings.facebookSubtitle, iconName: MobileSettingsUIAsset.facebook.name, action: .web(URL(websitePath: "contact/facebook"))),
            Row(id: "threads", title: Strings.threadsTitle, subtitle: Strings.threadsSubtitle, iconName: MobileSettingsUIAsset.threads.name, action: .web(URL(websitePath: "contact/threads"))),
            Row(id: "x", title: Strings.twitterTitle, subtitle: Strings.twitterSubtitle, iconName: MobileSettingsUIAsset.x.name, action: .web(URL(websitePath: "contact/x"))),
        ])
    }

    // MARK: Other Apps

    private static var otherAppsSection: Section {
        Section(id: .otherApps, header: MobileSettingsUI.Strings.SettingsContentOtherAppsSection.header, rows: [
            otherAppRow(name: "Barc", subtitle: "Save and store loyalty cards", id: "6642707689", iconName: MobileSettingsUIAsset.barc.name),
            otherAppRow(name: "Kineo", subtitle: "Draw flipbook-style animations", id: "286948844", iconName: MobileSettingsUIAsset.kineo.name),
            otherAppRow(name: "Debigulator", subtitle: "Shrink images to send faster", id: "1510076117", iconName: MobileSettingsUIAsset.debigulator.name),
        ])
    }

    private static func otherAppRow(name: String, subtitle: String, id: String, iconName: String) -> Row {
        Row(
            id: "otherApp.\(id)",
            title: name,
            subtitle: subtitle,
            iconName: iconName,
            action: .openURL(appStoreURL(id: id))
        )
    }

    static func appStoreURL(id: String) -> URL {
        let urlString = "https://apps.apple.com/us/app/cocoatype/id\(id)?uo=4"
        guard let url = URL(string: urlString)
        else { Container.shared.errorHandler().crash("Invalid App Store URL: \(urlString)") }
        return url
    }
}

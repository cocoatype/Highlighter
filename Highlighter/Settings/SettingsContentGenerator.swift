//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SafariServices
import SwiftUI

struct SettingsContentGenerator {
    private let purchaseState: PurchaseState
    init(state: PurchaseState) {
        self.purchaseState = state
    }

    var content: some View {
        Group {
            if case .purchased = purchaseState {
                Section {
                    SettingsNavigationLink("SettingsContentProvider.Item.autoRedactions", destination: Text?.none)
                }
            } else {
                Section {
                    PurchaseNavigationLink(state: purchaseState, destination: PurchaseMarketingView())
                }
            }
            Section {
                WebURLButton("SettingsContentProvider.Item.about", path: "about")
                WebURLButton("SettingsContentProvider.Item.privacy", path: "privacy")
                WebURLButton("SettingsContentProvider.Item.acknowledgements", path: "acknowledgements")
                WebURLButton("SettingsContentProvider.Item.contact", path: "contact")
            }
            Section(header: SettingsSectionHeader("SettingsContentProvider.Section.otherApps.header")) {
                OtherAppButton(name: "Kineo", subtitle: "Draw flipbook-style animations", id: "286948844")
                OtherAppButton(name: "Scrawl", subtitle: "definitely an app", id: "1229326968")
                OtherAppButton(name: "Debigulator", subtitle: "Shrink images to send faster", id: "1510076117")
            }
        }
    }
}

struct WebURLButton: View {
//    @Binding private var selection: URL?
    private let titleKey: LocalizedStringKey
    private let url: URL
    @State private var selected = false
    init(_ titleKey: LocalizedStringKey, path: String) {
//        self._selection = selection
        self.titleKey = titleKey
        self.url = Self.baseURL.appendingPathComponent(path)
    }

    var body: some View {
        Button(titleKey) {
            selected = true
        }.sheet(isPresented: $selected) {
            WebView(url: url)
        }.settingsCell()
    }

    static let baseURL: URL = {
        guard let url = URL(string: "https://blackhighlighter.app/") else { fatalError("Invalid base URL for settings") }
        return url
    }()
}

struct WebView: UIViewControllerRepresentable {
    private let url: URL
    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(context: Context) -> WebViewController {
        return WebViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {}
}

extension URL: Identifiable {
    public typealias ID = Int
    public var id: Int { hashValue }
}

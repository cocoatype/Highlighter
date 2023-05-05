//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Editing
import SwiftUI

struct SettingsAlertButton: View {
    @State private var showAlert = false
    init(_ titleKey: LocalizedStringKey, _ subtitle: String? = nil) {
        self.titleKey = titleKey
        self.subtitle = subtitle
    }

    @ViewBuilder
    var body: some View {
        if /*purchaseState != .purchased &&*/ hideAutoRedactions == false {
            Button(action: {
                showAlert = true
            }) {
                VStack(alignment: .leading) {
                    WebURLTitleText(titleKey)
                    if let subtitle = subtitle {
                        WebURLSubtitleText(subtitle)
                    }
                }
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text("SettingsView.notPurchasedAlertTitle"),
                    message: Text("SettingsView.notPurchasedAlertMessage"),
                    primaryButton: .cancel(Text("SettingsView.notPurchasedDismissButton")),
                    secondaryButton: .default(Text("SettingsView.notPurchasedHideButton")) {
                        hideAutoRedactions = true
                    })
            }.settingsCell()
        }
    }

    // MARK: Boilerplate

    private let titleKey: LocalizedStringKey
    private let subtitle: String?

    @Defaults.Value(key: .hideAutoRedactions) private var hideAutoRedactions: Bool
}

struct SettingsAlertTitleText: View {
    private let key: LocalizedStringKey
    init(_ key: LocalizedStringKey) {
        self.key = key
    }

    var body: some View {
        Text(key)
            .font(.app(textStyle: .subheadline))
            .foregroundColor(.white)
    }
}

struct SettingsAlertSubtitleText: View {
    private let text: String
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.app(textStyle: .footnote))
            .foregroundColor(.primaryExtraLight)
    }
}


struct SettingsAlertButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            WebURLButton("Hello", path: "world")
            WebURLButton("Hello", "world!", path: "world")
        }.preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}

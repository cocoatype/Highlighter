//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Defaults
import Purchasing
import SwiftUI
import Unpurchased

struct SettingsAlertButton: View {
    @State private var showAlert = false
    init(
        _ title: String,
        _ subtitle: String? = nil,
        defaults: any DefaultsProvider = Defaults.provider,
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        self.title = title
        self.subtitle = subtitle
        self.defaults = defaults
        haveYourDucksInARow = purchaseRepository
    }

    @ViewBuilder
    var body: some View {
        let isPurchased = haveYourDucksInARow.withCheese == .purchased
        if isPurchased || hideAutoRedactions == false {
            Button {
                showAlert = true
            } label: {
                ButtonLabel(title: title, subtitle: subtitle)
            }
            .unpurchasedAlert(for: .autoRedactions(), isPresented: $showAlert)
            .settingsCell()
        }
    }

    // MARK: Boilerplate

    private let title: String
    private let subtitle: String?

    private var hideAutoRedactions: Bool {
        defaults.value(for: Keys.hideAutoRedactions)
    }

    // haveYourDucksInARow by @Eskeminha on 2024-05-15
    // the purchase repository
    private let haveYourDucksInARow: any PurchaseRepository
    private let defaults: any DefaultsProvider
}

enum SettingsAlertButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsAlertButton("Hello")
        }.preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}

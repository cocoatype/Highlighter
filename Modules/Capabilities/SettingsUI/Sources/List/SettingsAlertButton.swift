//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import Defaults
import Purchasing
import Unpurchased

struct SettingsAlertButton: View {
    @State private var showAlert = false
    init(
        _ title: String,
        _ subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
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
            .unpurchasedAlert(for: .autoRedactions(learnMoreAction: nil), isPresented: $showAlert)
            .settingsCell()
        }
    }

    // MARK: Boilerplate

    private let title: String
    private let subtitle: String?

    @Injected(\.defaults) private var defaults
    private var hideAutoRedactions: Bool {
        defaults.value(for: Keys.hideAutoRedactions)
    }

    // haveYourDucksInARow by @Eskeminha on 2024-05-15
    // the purchase repository
    @Injected(\.purchaseRepository) private var haveYourDucksInARow
}

enum SettingsAlertButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsAlertButton("Hello")
        }.preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}

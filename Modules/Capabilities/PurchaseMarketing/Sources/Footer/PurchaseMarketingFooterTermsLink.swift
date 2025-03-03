//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooterTermsLink: View {
    private let usesShortTitle: Bool
    init(usesShortTitle: Bool) {
        self.usesShortTitle = usesShortTitle
    }

    @Environment(\.openURL) private var openURL
    private func openTerms() {
        guard let termsURL = URL(string: "https://blackhighlighter.app/terms/") else { return }
        openURL(termsURL)
    }

    var body: some View {
        if usesShortTitle {
            PurchaseMarketingFooterLink(title: Strings.shortTitle, action: openTerms)
        } else {
            PurchaseMarketingFooterLink(title: Strings.title, action: openTerms)
        }
    }

    private typealias Strings = PurchaseMarketingStrings.PurchaseMarketingFooterTermsLink
}

//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct FooterTermsLink: View {
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
            FooterLink(title: Strings.shortTitle, action: openTerms)
        } else {
            FooterLink(title: Strings.title, action: openTerms)
        }
    }

    private typealias Strings = PaywallStrings.FooterTermsLink
}

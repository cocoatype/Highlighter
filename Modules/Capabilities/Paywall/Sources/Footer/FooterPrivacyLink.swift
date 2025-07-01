//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct FooterPrivacyLink: View {
    private let usesShortTitle: Bool
    init(usesShortTitle: Bool) {
        self.usesShortTitle = usesShortTitle
    }

    @Environment(\.openURL) private var openURL
    private func openPrivacy() {
        guard let privacyURL = URL(string: "https://blackhighlighter.app/privacy/") else { return }
        openURL(privacyURL)
    }

    var body: some View {
        if usesShortTitle {
            FooterLink(
                title: PaywallStrings.FooterPrivacyLink.shortTitle,
                action: openPrivacy
            )
        } else {
            FooterLink(
                title: PaywallStrings.FooterPrivacyLink.title,
                action: openPrivacy
            )
        }
    }
}

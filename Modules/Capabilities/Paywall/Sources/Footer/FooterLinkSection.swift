//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct FooterLinkSection: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            // Restore Purchases — Terms & Conditions — Privacy Policy
            HStack {
                FooterRestoreLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: false)
            }

            // Restore — Terms & Conditions — Privacy Policy
            HStack {
                FooterRestoreLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: false)
            }

            // Restore — Terms & Conditions — Privacy
            HStack {
                FooterRestoreLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: true)
            }

            // Restore — Terms — Privacy
            HStack {
                FooterRestoreLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: true)
            }

            // Restore Purchases — Terms & Conditions — Privacy Policy
            VStack {
                FooterRestoreLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: false)
            }
            .frame(maxWidth: .infinity)

            // Restore — Terms & Conditions — Privacy Policy
            VStack {
                FooterRestoreLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: false)
            }
            .frame(maxWidth: .infinity)

            // Restore — Terms & Conditions — Privacy
            VStack {
                FooterRestoreLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: false)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: true)
            }
            .frame(maxWidth: .infinity)

            // Restore — Terms — Privacy
            VStack {
                FooterRestoreLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterTermsLink(usesShortTitle: true)
                FooterLinkSeparator()
                FooterPrivacyLink(usesShortTitle: true)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    FooterLinkSection()
}

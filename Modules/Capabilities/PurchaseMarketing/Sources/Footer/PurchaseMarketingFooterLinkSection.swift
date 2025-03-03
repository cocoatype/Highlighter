//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct PurchaseMarketingFooterLinkSection: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            // Restore Purchases — Terms & Conditions — Privacy Policy
            HStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: false)
            }

            // Restore — Terms & Conditions — Privacy Policy
            HStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: false)
            }

            // Restore — Terms & Conditions — Privacy
            HStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: true)
            }

            // Restore — Terms — Privacy
            HStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: true)
            }

            // Restore Purchases — Terms & Conditions — Privacy Policy
            VStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: false)
            }
            .frame(maxWidth: .infinity)

            // Restore — Terms & Conditions — Privacy Policy
            VStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: false)
            }
            .frame(maxWidth: .infinity)

            // Restore — Terms & Conditions — Privacy
            VStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: false)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: true)
            }
            .frame(maxWidth: .infinity)

            // Restore — Terms — Privacy
            VStack {
                PurchaseMarketingFooterRestoreLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterTermsLink(usesShortTitle: true)
                PurchaseMarketingFooterLinkSeparator()
                PurchaseMarketingFooterPrivacyLink(usesShortTitle: true)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    PurchaseMarketingFooterLinkSection()
}

//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingItem: View {
    private let headerKey: LocalizedStringKey
    private let textKey: LocalizedStringKey
    init(header: LocalizedStringKey, text: LocalizedStringKey) {
        self.headerKey = header
        self.textKey = text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PurchaseMarketingHeader(headerKey)
            PurchaseMarketingText(textKey)
        }
    }
}

struct PurchaseMarketingItemPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingItem(header: "PurchaseMarketingView.supportDevelopmentHeader", text: "PurchaseMarketingView.supportDevelopmentText").preferredColorScheme(.dark)
    }
}

//  Created by Geoff Pado on 2/2/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingTopBarCompact: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PurchaseMarketingTopBarHeadline()
            PurchaseMarketingTopBarSubheadline()
            if #available(iOS 15, *) {
                PurchaseMarketingTopBarButtonStack()
            } else {
                LegacyPurchaseMarketingTopBarButtonStack()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
        .background(Color.primaryDark.ignoresSafeArea())
    }
}

struct PurchaseMarketingTopBarCompactPreviews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            PurchaseMarketingTopBarCompact()
        }.ignoresSafeArea()
    }
}

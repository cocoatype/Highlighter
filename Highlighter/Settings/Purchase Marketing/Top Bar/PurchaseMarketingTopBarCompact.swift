//  Created by Geoff Pado on 2/2/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingTopBarCompact: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PurchaseMarketingTopBarHeadline().lineLimit(0)
            PurchaseMarketingTopBarSubheadline()
            HStack {
                PurchaseButton()
                PurchaseButtonSeparator()
                PurchaseRestoreButton()
            }
        }
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryDark)
    }
}

struct PurchaseMarketingTopBarCompactPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingTopBarCompact()
    }
}

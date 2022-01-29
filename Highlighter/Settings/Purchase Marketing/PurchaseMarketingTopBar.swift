//  Created by Geoff Pado on 1/19/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingTopBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PurchaseMarketingTopBarText()
            PurchaseButton()
        }
        .padding(30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryDark)
    }
}

struct PurchaseMarketingTopBarPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingTopBar().previewLayout(.sizeThatFits)
    }
}

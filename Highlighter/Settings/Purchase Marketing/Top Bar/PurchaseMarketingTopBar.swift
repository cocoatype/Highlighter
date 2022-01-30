//  Created by Geoff Pado on 1/19/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingTopBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            PurchaseMarketingTopBarText()
            HStack {
                PurchaseButton()
                PurchaseButtonSeparator()
                PurchaseRestoreButton()
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryDark)
    }
}

struct PurchaseButtonSeparator: View {
    var body: some View {
        Text("PurchaseButtonSeparator.text")
            .font(.app(textStyle: .headline))
            .foregroundColor(.white)
    }
}

struct PurchaseMarketingTopBarPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingTopBar().previewLayout(.sizeThatFits)
    }
}

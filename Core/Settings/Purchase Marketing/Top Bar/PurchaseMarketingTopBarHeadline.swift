//  Created by Geoff Pado on 1/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingTopBarHeadline: View {
    var body: some View {
        Text("PurchaseMarketingTopBarHeadlineLabel.text")
            .foregroundColor(.white)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .font(.app(textStyle: .largeTitle))
    }
}

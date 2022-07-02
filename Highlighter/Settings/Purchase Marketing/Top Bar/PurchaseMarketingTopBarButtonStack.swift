//  Created by Geoff Pado on 7/1/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 15, *)
struct PurchaseMarketingTopBarButtonStack: View {
    @ViewBuilder
    var body: some View {
        switch dynamicTypeSize {
        case .accessibility3, .accessibility4, .accessibility5:
            VStack(alignment: .leading) {
                PurchaseMarketingTopBarButtons()
            }
        default:
            HStack {
                PurchaseMarketingTopBarButtons()
            }
        }
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
}

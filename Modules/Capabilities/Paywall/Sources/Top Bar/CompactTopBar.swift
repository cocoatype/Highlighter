//  Created by Geoff Pado on 2/2/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct CompactTopBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TopBarHeadline()
            TopBarSubheadline()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
        .background(Color.primaryDark.ignoresSafeArea())
    }
}

enum PurchaseMarketingTopBarCompactPreviews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CompactTopBar()
        }.ignoresSafeArea()
    }
}

//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseTitle: View {
    var body: some View {
        return Text("PurchaseItem.title")
            .font(.app(textStyle: .title3))
            .foregroundColor(.white)
    }
}

struct PurchaseTitlePreviews: PreviewProvider {
    static var previews: some View {
        PurchaseTitle().preferredColorScheme(.dark)
    }
}

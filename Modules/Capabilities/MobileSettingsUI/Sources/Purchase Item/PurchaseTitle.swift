//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseTitle: View {
    var body: some View {
        return Text(Strings.PurchaseItem.title)
            .font(.app(textStyle: .title3))
            .foregroundColor(.white)
    }
}

enum PurchaseTitlePreviews: PreviewProvider {
    static var previews: some View {
        PurchaseTitle().preferredColorScheme(.dark)
    }
}

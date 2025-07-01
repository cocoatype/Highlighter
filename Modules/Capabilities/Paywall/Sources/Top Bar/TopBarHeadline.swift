//  Created by Geoff Pado on 1/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct TopBarHeadline: View {
    var body: some View {
        Text(PaywallStrings.TopBarHeadline.text)
            .foregroundColor(.white)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .font(.app(textStyle: .largeTitle))
    }
}

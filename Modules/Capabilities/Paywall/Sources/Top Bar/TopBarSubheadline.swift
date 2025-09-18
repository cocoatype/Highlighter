//  Created by Geoff Pado on 1/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import DesignSystem
import SwiftUI

struct TopBarSubheadline: View {
    var body: some View {
        Text(Strings.TopBarSubheadline.text)
            .foregroundColor(.primaryUltraLight)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .font(.app(textStyle: .body))
    }
}

//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 16.0, *)
struct FooterLinkSeparator: View {
    var body: some View {
        Text(verbatim: " — ")
            .accessibilityHidden(true)
            .font(.footnote)
            .foregroundStyle(.white)
    }
}

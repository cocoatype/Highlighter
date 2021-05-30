//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingStack<Content: View>: View {
    @Environment(\.readableWidth) var readableWidth: CGFloat
    private let content: (() -> Content)
    init(@ViewBuilder content: @escaping (() -> Content)) {
        self.content = content
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 26, content: content)
            .frame(width: readableWidth, alignment: .center)
            .padding(.top, 20)
    }
}

//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import SwiftUI

import DesignSystem

@available(iOS 16.0, *)
struct FooterPurchaseButtonLabel: View {
    private let title: String
    init(title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.app(textStyle: .headline))
            .fontWeight(.bold)
            .foregroundStyle(Color.white)
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primaryLight)
            }
    }
}

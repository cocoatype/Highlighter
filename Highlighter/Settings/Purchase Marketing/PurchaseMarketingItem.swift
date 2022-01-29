//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingItem: View {
    init(header: LocalizedStringKey, text: LocalizedStringKey, imageName: String) {
        self.headerKey = header
        self.textKey = text
        self.imageName = imageName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                PurchaseMarketingHeader(headerKey)
                PurchaseMarketingText(textKey)
            }.padding(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
            Image(imageName).resizable().aspectRatio(290.0/166.0, contentMode: .fit)
        }
        .background(Color.cellBackground)
        .cornerRadius(21)
    }

    private let headerKey: LocalizedStringKey
    private let textKey: LocalizedStringKey
    private let imageName: String
}

struct PurchaseMarketingItemPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            PurchaseMarketingItem(header: "PurchaseMarketingView.supportDevelopmentHeader", text: "PurchaseMarketingView.supportDevelopmentText", imageName: "Support")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appPrimary)
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 290, height: 242))
    }
}

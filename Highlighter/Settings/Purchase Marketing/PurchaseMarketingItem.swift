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
            Image(imageName).resizable().aspectRatio(379.0/284.0, contentMode: .fit)
            VStack(alignment: .leading, spacing: 8) {
                PurchaseMarketingHeader(headerKey)
                PurchaseMarketingText(textKey)
            }.padding()
        }
        .background(Color.primaryDark)
        .cornerRadius(21)
        .shadow(radius: 4)
    }

    private let headerKey: LocalizedStringKey
    private let textKey: LocalizedStringKey
    private let imageName: String
}

struct PurchaseMarketingItemPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            PurchaseMarketingItem(header: "PurchaseMarketingView.supportDevelopmentHeader", text: "PurchaseMarketingView.supportDevelopmentText", imageName: "shortcuts").padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appPrimary)
        .preferredColorScheme(.dark)
    }
}

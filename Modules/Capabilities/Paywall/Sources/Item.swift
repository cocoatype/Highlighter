//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct Item: View {
    init(header: String, text: String, imageName: String) {
        self.header = header
        self.text = text
        self.imageName = imageName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                ItemHeader(header)
                ItemText(text)
            }.padding(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))
            Image(imageName).resizable().aspectRatio(290.0/166.0, contentMode: .fit)
        }
        .background(Color.cellBackground)
        .cornerRadius(21)
    }

    private let header: String
    private let text: String
    private let imageName: String
}

enum PurchaseMarketingItemPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            Item(header: "PurchaseMarketingView.supportDevelopmentHeader", text: "PurchaseMarketingView.supportDevelopmentText", imageName: "Support")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appPrimary)
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 290, height: 242))
    }
}

//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingText: View {
    private let titleKey: LocalizedStringKey
    init(_ titleKey: LocalizedStringKey) {
        self.titleKey = titleKey
    }

    var body: some View {
        Text(titleKey)
            .lineSpacing(3)
            .font(.app(textStyle: Self.textStyle))
            .foregroundColor(Color(.white))
    }

    private static let textStyle: UIFont.TextStyle = {
        #if targetEnvironment(macCatalyst)
        return .body
        #else
        return .footnote
        #endif
    }()
}

struct PurchaseMarketingTextPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingText("PurchaseMarketingView.supportDevelopmentText")
            .preferredColorScheme(.dark)
    }
}

//  Created by Geoff Pado on 5/18/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingView: View {
    var body: some View {
        VStack {
            PurchaseMarketingTopBar()
            ScrollView {
                LazyVGrid(columns: [GridItem(spacing: 20), GridItem(spacing: 20)], spacing: 20) {
                    PurchaseMarketingItem(
                        header: "PurchaseMarketingView.autoRedactionsHeader",
                        text: "PurchaseMarketingView.autoRedactionsText",
                        imageName: "Seek")
                    #if !targetEnvironment(macCatalyst)
                    PurchaseMarketingItem(
                        header: "PurchaseMarketingView.documentScanningHeader",
                        text: "PurchaseMarketingView.documentScanningText",
                        imageName: "Scanner")
                    #endif
                    PurchaseMarketingItem(
                        header: "PurchaseMarketingView.shortcutsHeader",
                        text: "PurchaseMarketingView.shortcutsText",
                        imageName: "Shortcuts")
                    PurchaseMarketingItem(
                        header: "PurchaseMarketingView.supportDevelopmentHeader",
                        text: "PurchaseMarketingView.supportDevelopmentText",
                        imageName: "Support")
                    PurchaseMarketingItem(
                        header: "PurchaseMarketingView.crossPlatformHeader",
                        text: "PurchaseMarketingView.crossPlatformText",
                        imageName: "Systems")
                }.padding(EdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20))
            }
        }
        .fill()
        .background(Color(.primary))
        .navigationBarItems(trailing: PurchaseRestoreButton())
    }
}

struct PurchaseMarketingView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingView()
            .preferredColorScheme(.dark)
            .environment(\.readableWidth, 288)
            .previewLayout(.fixed(width: 640, height: 1024))
    }
}

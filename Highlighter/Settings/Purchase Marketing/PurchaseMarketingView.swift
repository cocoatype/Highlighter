//  Created by Geoff Pado on 5/18/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingView: View {
    var body: some View {
        HStack {
            PurchaseMarketingStack {
                PurchaseMarketingItem(
                    header: "PurchaseMarketingView.autoRedactionsHeader",
                    text: "PurchaseMarketingView.autoRedactionsText")
                #if !targetEnvironment(macCatalyst)
                PurchaseMarketingItem(
                    header: "PurchaseMarketingView.documentScanningHeader",
                    text: "PurchaseMarketingView.documentScanningText")
                #endif
                PurchaseMarketingItem(
                    header: "PurchaseMarketingView.supportDevelopmentHeader",
                    text: "PurchaseMarketingView.supportDevelopmentText")
                PurchaseButton()
                Spacer()
            }
        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color(.primary))
        .navigationBarItems(trailing: PurchaseRestoreButton())
    }
}

struct PurchaseMarketingView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingView()
            .preferredColorScheme(.dark)
            .environment(\.readableWidth, 288)
    }
}

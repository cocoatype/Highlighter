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
                PurchaseMarketingItem(
                    header: "PurchaseMarketingView.documentScanningHeader",
                    text: "PurchaseMarketingView.documentScanningText")
                PurchaseMarketingItem(
                    header: "PurchaseMarketingView.supportDevelopmentHeader",
                    text: "PurchaseMarketingView.supportDevelopmentText")
                PurchaseButton()
                Spacer()
            }
        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color(.primary))
    }
}

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

struct PurchaseMarketingView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingView()
            .preferredColorScheme(.dark)
            .environment(\.readableWidth, 288)
    }
}

struct PurchaseMarketingItem: View {
    private let headerKey: LocalizedStringKey
    private let textKey: LocalizedStringKey
    init(header: LocalizedStringKey, text: LocalizedStringKey) {
        self.headerKey = header
        self.textKey = text
    }

    var body: some View {
        VStack(alignment: .leading) {
            PurchaseMarketingHeader(headerKey)
            PurchaseMarketingText(textKey)
        }
    }
}

struct PurchaseMarketingHeader: View {
    private let titleKey: LocalizedStringKey
    init(_ titleKey: LocalizedStringKey) {
        self.titleKey = titleKey
    }

    var body: some View {
        Text(titleKey)
            .font(.app(textStyle: .title2))
            .foregroundColor(.white)
    }
}

struct PurchaseMarketingText: View {
    private let titleKey: LocalizedStringKey
    init(_ titleKey: LocalizedStringKey) {
        self.titleKey = titleKey
    }

    var body: some View {
        Text(titleKey)
            .font(.app(textStyle: .subheadline))
            .foregroundColor(Color(.primaryExtraLight))
    }
}

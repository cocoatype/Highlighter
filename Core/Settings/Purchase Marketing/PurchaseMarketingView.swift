//  Created by Geoff Pado on 5/18/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct PurchaseMarketingView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Color.primaryDark
                Color.appPrimary
            }.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .topTrailing) {
                        topBar(forWidth: proxy.size.width)
                        PurchaseMarketingCloseButton()
                    }
                    LazyVGrid(columns: columns(forWidth: proxy.size.width), spacing: 20) {
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
                        .background(Color.appPrimary)
                }
            }
            .fill()
            .navigationBarHidden(true)
        }
    }

    private static let breakWidth = Double(640)

    @ViewBuilder
    private func topBar(forWidth width: Double) -> some View {
        if width < Self.breakWidth {
            PurchaseMarketingTopBarCompact()
        } else {
            PurchaseMarketingTopBarRegular()
        }
    }

    private func columns(forWidth width: Double) -> [GridItem] {
        if width < Self.breakWidth {
            return [GridItem(spacing: 20)]
        } else {
            return [GridItem(spacing: 20), GridItem(spacing: 20)]
        }
    }
}

struct PurchaseMarketingCloseButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        #if targetEnvironment(macCatalyst)
        EmptyView()
        #else
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.app(textStyle: .headline))
                .foregroundColor(.white)
                .padding(20)
        }
        #endif
    }
}

struct PurchaseMarketingView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingView()
            .preferredColorScheme(.dark)
            .environment(\.readableWidth, 288)
//            .previewLayout(.fixed(width: 640, height: 1024))
    }
}

//  Created by Geoff Pado on 5/18/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import DesignSystem
import Logging
import Purchasing
import TestHelpersInterface

@available(iOS 16.0, *)
public struct PaywallView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Injected(\.logger) private var logger

    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Color.primaryDark
                Color.appPrimary
            }.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .topTrailing) {
                        topBar(forWidth: proxy.size.width)
                        CloseButton()
                    }
                    LazyVGrid(columns: columns(forWidth: proxy.size.width), spacing: 20) {
                        Item(
                            header: Strings.autoRedactionsHeader,
                            text: Strings.autoRedactionsText,
                            imageName: "Seek")
                        #if !targetEnvironment(macCatalyst)
                        Item(
                            header: Strings.documentScanningHeader,
                            text: Strings.documentScanningText,
                            imageName: "Scanner")
                        #endif
                        Item(
                            header: Strings.shortcutsHeader,
                            text: Strings.shortcutsText,
                            imageName: "Shortcuts")
                        Item(
                            header: Strings.supportDevelopmentHeader,
                            text: Strings.supportDevelopmentText,
                            imageName: "Support")
                        Item(
                            header: Strings.crossPlatformHeader,
                            text: Strings.crossPlatformText,
                            imageName: "Systems")
                    }.padding(EdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20))
                        .background(Color.appPrimary)
                }
            }
            .fill()
            .navigationBarHidden(true)
        }.safeAreaInset(edge: .bottom) {
            // this line causes a previews crash because of the purchase repository
            Footer()
                .background(Color.appPrimary, ignoresSafeAreaEdges: .bottom)
        }
        .onAppear {
            logger.log(Event(name: .purchaseMarketingDisplayed))
        }
    }

    private static let breakWidth = Double(640)

    @ViewBuilder
    private func topBar(forWidth width: Double) -> some View {
        if width < Self.breakWidth {
            CompactTopBar()
        } else {
            RegularTopBar()
        }
    }

    private func columns(forWidth width: Double) -> [GridItem] {
        if width < Self.breakWidth {
            return [GridItem(spacing: 20)]
        } else {
            return [GridItem(spacing: 20), GridItem(spacing: 20)]
        }
    }

    private typealias Strings = PaywallStrings.PaywallView
    let inspection = Inspection<Self>()
}

@available(iOS 16.0, *)
#Preview {
    Color.black
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            PaywallView()
                .frame(width: 640)
        }
}

extension Event.Name {
    static let purchaseMarketingDisplayed = Event.Name("PurchaseMarketingView.displayed")
}

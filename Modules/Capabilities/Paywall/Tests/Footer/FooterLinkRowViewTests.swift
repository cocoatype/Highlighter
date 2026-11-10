//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import Paywall

@MainActor
struct FooterLinkRowViewTests {
    @Test func layoutOrderMatchesViewThatFits() {
        let layouts = FooterLinkRowView.layouts
        #expect(layouts.count == 8)
        #expect(layouts.prefix(4).allSatisfy { $0.axis == .horizontal })
        #expect(layouts.suffix(4).allSatisfy { $0.axis == .vertical })
        #expect(layouts.first == FooterLinkRowView.Layout(axis: .horizontal, usesShortRestoreTitle: false, usesShortTermsTitle: false, usesShortPrivacyTitle: false))
        #expect(layouts.last == FooterLinkRowView.Layout(axis: .vertical, usesShortRestoreTitle: true, usesShortTermsTitle: true, usesShortPrivacyTitle: true))
    }

    @Test func wideWidthUsesLongHorizontalLayout() {
        let row = FooterLinkRowView()
        row.selectLayout(forWidth: 2000)
        #expect(row.currentLayout == FooterLinkRowView.layouts.first)
    }

    @Test func narrowWidthFallsBackToVerticalLayout() {
        let row = FooterLinkRowView()
        row.selectLayout(forWidth: 60)
        #expect(row.currentLayout?.axis == .vertical)
    }

    @Test func layoutsGetNarrowerInOrder() {
        let row = FooterLinkRowView()
        var previousIndex = 0
        for width in stride(from: CGFloat(600), through: 40, by: -10) {
            row.selectLayout(forWidth: width)
            let index = FooterLinkRowView.layouts.firstIndex { $0 == row.currentLayout } ?? 0
            #expect(index >= previousIndex)
            previousIndex = index
        }
    }

    @Test func titles() {
        #expect(FooterLinkRowView.title(for: .restore, usesShortTitle: false) == Strings.FooterRestoreLink.title)
        #expect(FooterLinkRowView.title(for: .terms, usesShortTitle: true) == Strings.FooterTermsLink.shortTitle)
        #expect(FooterLinkRowView.title(for: .privacy, usesShortTitle: false) == Strings.FooterPrivacyLink.title)
    }
}

//  Created by Geoff Pado on 1/26/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit
import SwiftUI

struct PurchaseMarketingTopBarText: View {
    @State private var textWidth: CGFloat?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PurchaseMarketingTopBarHeadline().modifier(SetWidthViewModifier(textWidth: $textWidth))
            PurchaseMarketingTopBarSubheadline().modifier(GetWidthViewModifier(textWidth: $textWidth))
        }
    }

    struct TextWidthPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = .zero

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = min(value, nextValue())
        }
    }

    struct SetWidthViewModifier: ViewModifier {
        @Binding var textWidth: CGFloat?
        init(textWidth: Binding<CGFloat?>) {
            _textWidth = textWidth
        }

        func body(content: Content) -> some View {
            content
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: TextWidthPreferenceKey.self, value: proxy.size.width)
                })
                .frame(width: textWidth, alignment: .leading)
                .onPreferenceChange(TextWidthPreferenceKey.self) {
                    textWidth = $0
                }
        }
    }

    struct GetWidthViewModifier: ViewModifier {
        @Binding var textWidth: CGFloat?
        init(textWidth: Binding<CGFloat?>) {
            _textWidth = textWidth
        }

        func body(content: Content) -> some View {
            content
                .frame(width: textWidth, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .onPreferenceChange(TextWidthPreferenceKey.self) {
                    textWidth = $0
                }
        }
    }
}

struct PurchaseMarketingTopBarTextPreviews: PreviewProvider {
    static var previews: some View {
        PurchaseMarketingTopBarText().background(Color.black).previewLayout(.sizeThatFits)
    }
}

struct PurchaseMarketingTopBarHeadline: View {
    var body: some View {
        Text("Ultra Highlighter")
            .font(.app(textStyle: .largeTitle))
            .foregroundColor(.white)
            .lineLimit(1)
    }
}

struct PurchaseMarketingTopBarSubheadline: View {
    var body: some View {
        Text("Some amount of text here about how cool the extra features are.")
            .font(.app(textStyle: .body))
            .foregroundColor(.primaryUltraLight)
    }
}

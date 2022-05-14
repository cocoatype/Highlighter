//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct WebURLButton: View {
    @State private var selected = false
    init(_ titleKey: LocalizedStringKey, _ subtitle: String? = nil, path: String) {
        self.titleKey = titleKey
        self.subtitle = subtitle
        self.url = Self.url(forPath: path)
    }

    var body: some View {
        Button(action: {
            selected = true
        }) {
            VStack(alignment: .leading) {
                WebURLTitleText(titleKey)
                if let subtitle = subtitle {
                    WebURLSubtitleText(subtitle)
                }
            }
        }.sheet(isPresented: $selected) {
            WebView(url: url)
        }.settingsCell()
    }

    static let baseURL: URL = {
        guard let url = URL(string: "https://blackhighlighter.app/") else { fatalError("Invalid base URL for settings") }
        return url
    }()

    static func url(forPath path: String) -> URL {
        Self.baseURL.appendingPathComponent(path)
    }

    // MARK: Boilerplate

    private let titleKey: LocalizedStringKey
    private let subtitle: String?
    private let url: URL
}

struct WebURLTitleText: View {
    private let key: LocalizedStringKey
    init(_ key: LocalizedStringKey) {
        self.key = key
    }

    var body: some View {
        Text(key)
            .font(.app(textStyle: .subheadline))
            .foregroundColor(.white)
    }
}

struct WebURLSubtitleText: View {
    private let text: String
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.app(textStyle: .footnote))
            .foregroundColor(.primaryExtraLight)
    }
}


struct WebURLButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            WebURLButton("Hello", path: "world")
            WebURLButton("Hello", "world!", path: "world")
        }.preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}

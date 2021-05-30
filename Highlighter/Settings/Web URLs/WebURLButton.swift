//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct WebURLButton: View {
    private let titleKey: LocalizedStringKey
    private let url: URL
    @State private var selected = false
    init(_ titleKey: LocalizedStringKey, path: String) {
        self.titleKey = titleKey
        self.url = Self.url(forPath: path)
    }

    var body: some View {
        Button(titleKey) {
            selected = true
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
}

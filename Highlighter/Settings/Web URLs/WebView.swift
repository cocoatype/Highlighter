//  Created by Geoff Pado on 5/30/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct WebView: UIViewControllerRepresentable {
    private let url: URL
    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(context: Context) -> WebViewController {
        return WebViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {}
}

//  Created by Geoff Pado on 12/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import StoreKit
import SwiftUI

@available(iOS 16.0, *)
struct FooterRestoreLink: View {
    private let usesShortTitle: Bool
    init(usesShortTitle: Bool) {
        self.usesShortTitle = usesShortTitle
    }

    private func restore() {
        Task {
            try await AppStore.sync()
        }
    }

    var body: some View {
        if usesShortTitle {
            FooterLink(
                title: Strings.FooterRestoreLink.shortTitle,
                action: restore
            )
        } else {
            FooterLink(
                title: Strings.FooterRestoreLink.title,
                action: restore
            )
        }
    }
}

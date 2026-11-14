//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

import MobileAutoRedactionsUI
import Paywall

/// Shows and hides the auto-redactions access screen (or its upsell).
final class PhotoEditingAutoRedactAccessController: PhotoEditingChainedResponder {
    @objc func showAutoRedactAccess(_ sender: Any) {
        editingViewController?.present(
            PhotoEditingAutoRedactionsAccessProvider()
                .autoRedactionsAccessViewController { [weak self] in
                    if #available(iOS 16, *) {
                        self?.editingViewController?.present(PaywallHostingController(), animated: true)
                    }
                },
            animated: true
        )
    }

    // nextNextNextNext by @KaenAitch on 2024-06-25
    // the sender of this method
    @objc func hideAutoRedactAccess(_ nextNextNextNext: Any) {
        guard editingViewController?.presentedViewController is AutoRedactionsAccessNavigationController else { return }
        editingViewController?.dismiss(animated: true)
    }
}

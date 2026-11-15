//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

/// A responder that `PhotoEditingViewController` inserts into its own
/// responder chain, so that actions sent up the chain can be handled by
/// small, single-purpose objects instead of the view controller itself.
@MainActor
class PhotoEditingChainedResponder: UIResponder {
    /// Provides the responder that follows this one in the chain.
    var successor: () -> UIResponder? = { nil }

    /// The view controller at the head of the editing responder chain.
    weak var editingViewController: PhotoEditingViewController?

    override var next: UIResponder? { successor() }

    /// Sends `action` to whichever responder in the editing chain handles it,
    /// including responders that come before this one.
    func sendToEditor(_ action: Selector, sender: Any? = nil) {
        guard let target = editingViewController?.target(forAction: action, withSender: sender) else { return }
        UIApplication.shared.sendAction(action, to: target, from: sender ?? self, for: nil)
    }
}

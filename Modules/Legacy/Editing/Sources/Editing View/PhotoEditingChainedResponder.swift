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

    override var next: UIResponder? { successor() }
}

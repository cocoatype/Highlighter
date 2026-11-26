//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

/// Actions handled somewhere in the photo editing responder chain.
///
/// Senders use these selectors (rather than ones on a concrete class) so the
/// handlers can live in whichever responder is responsible for them.
@objc @MainActor public protocol PhotoEditingResponderActions: NSObjectProtocol {
    func refreshToolbarItems()
    func selectHighlighterTool(_ sender: UICommand)

    func toggleColorPicker(_ sender: Any)
    func showColorPicker(_ sender: Any)

    func sharePhoto(_ sender: Any)
}

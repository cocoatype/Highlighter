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

    func toggleSeeking(_ sender: Any)
    func startSeeking(_ sender: Any)
    func cancelSeeking(_ sender: Any)
    func finishSeeking(_ sender: Any)
    func seekBarDidChangeText(_ sender: UISearchTextField)

    func sharePhoto(_ sender: Any)
}

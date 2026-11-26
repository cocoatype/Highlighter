//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

/// Seek and Destroy actions handled somewhere in the photo editing responder
/// chain.
///
/// These are separate from `PhotoEditingResponderActions` so the Seek views
/// can send them without depending on the rest of the editor.
@objc @MainActor public protocol SeekActions: NSObjectProtocol {
    func toggleSeeking(_ sender: Any)
    func startSeeking(_ sender: Any)
    func cancelSeeking(_ sender: Any)
    func finishSeeking(_ sender: Any)
    func seekBarDidChangeText(_ sender: UISearchTextField)
}

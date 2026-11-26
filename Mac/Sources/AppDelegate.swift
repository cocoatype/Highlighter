//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }

    // An image document is always read from a file, so don't open an empty,
    // untitled one at launch. New from Clipboard is added in #610.
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        false
    }
}

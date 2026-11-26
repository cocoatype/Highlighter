//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import AppKit

@main
enum Launcher {
    @MainActor
    static func main() {
        // NSApplication holds its delegate weakly, so keep it alive for the
        // lifetime of the run loop.
        let delegate = AppDelegate()
        let application = NSApplication.shared
        application.delegate = delegate
        application.run()
    }
}

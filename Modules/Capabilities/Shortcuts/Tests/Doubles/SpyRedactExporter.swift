//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

import Redactions

@testable import Shortcuts

@available(iOS 16.0, *)
class SpyRedactExporter: ShortcutsRedactExporter {
    var redactionCount = 0

    override func export(_ input: IntentFile, redactions: [Redaction]) async throws -> IntentFile {
        redactionCount += redactions.count
        return input
    }
}

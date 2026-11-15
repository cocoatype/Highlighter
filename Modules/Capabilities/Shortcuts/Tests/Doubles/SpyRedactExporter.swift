//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import os

import Redactions

@testable import Shortcuts

@available(iOS 16.0, *)
final class SpyRedactExporter: RedactExporter {
    private let count = OSAllocatedUnfairLock(initialState: 0)
    var redactionCount: Int { count.withLock { $0 } }

    func export(
        _ input: IntentFile,
        redactions: [Redaction],
        outputFormat: OutputFormat
    ) async throws -> IntentFile {
        count.withLock { $0 += redactions.count }
        return input
    }
}

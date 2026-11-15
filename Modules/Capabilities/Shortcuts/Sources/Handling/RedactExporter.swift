//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import AppIntents

import Redactions

@available(iOS 16.0, *)
protocol RedactExporter: Sendable {
    func export(
        _ input: IntentFile,
        redactions: [Redaction],
        outputFormat: OutputFormat
    ) async throws -> IntentFile
}

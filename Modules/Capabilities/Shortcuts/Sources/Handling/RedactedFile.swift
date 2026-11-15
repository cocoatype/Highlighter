//  Created by Geoff Pado on 6/13/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import Redactions

@available(iOS 16, *)
struct RedactedFile: Sendable {
    let sourceImage: IntentFile
    let redactedImage: IntentFile
    let redactions: [Redaction]
}

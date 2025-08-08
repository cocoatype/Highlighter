//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

@available(iOS 16, *)
protocol IntentHandlerProvider {
    func handler(
        sourceImages: [IntentFile],
        selectedColor: ColorEntity?,
        outputFormat: OutputFormat
    ) -> any RedactIntentHandler
}

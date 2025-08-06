//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

@available(iOS 17.0, *)
enum RedactionStrategy: String, AppEnum {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "RedactionStrategy.typeDisplayRepresentation"

    static let caseDisplayRepresentations: [RedactionStrategy: DisplayRepresentation] = [
        autoRedactions: "RedactionStrategy.autoRedactions",
        detections: "RedactionStrategy.detections",
        everything: "RedactionStrategy.everything",
        words: "RedactionStrategy.words",
    ]

    case autoRedactions
    case detections
    case everything
    case words
}

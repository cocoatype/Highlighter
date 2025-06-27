//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

@available(iOS 16, *)
enum OutputFormat: String, AppEnum {
    case matchInput
    case jpeg
    case heic
    case png

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "OutputFormat.typeDisplayRepresentation"
    static let caseDisplayRepresentations: [OutputFormat: DisplayRepresentation] = [
        matchInput: "OutputFormat.matchInput",
        jpeg: "OutputFormat.jpeg",
        heic: "OutputFormat.heic",
        png: "OutputFormat.png",
    ]
}

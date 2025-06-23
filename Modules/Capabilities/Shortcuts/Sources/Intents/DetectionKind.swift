//  Created by Geoff Pado on 5/20/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import Detections

@available(iOS 16.0, *)
enum DetectionKind: String, AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "DetectionKind.typeDisplayRepresentation"

    static var caseDisplayRepresentations: [DetectionKind: DisplayRepresentation] = [
        names: "DetectionKind.names",
        addresses: "DetectionKind.addresses",
        phoneNumbers: "DetectionKind.phoneNumbers",
    ]

    case names
    case addresses
    case phoneNumbers

    var taggingFunction: ((String) -> [Substring]) {
        Category(detectionKind: self).getFuncyInSwizzleTown
    }
}

extension Detections.Category {
    @available(iOS 16.0, *)
    init(detectionKind: DetectionKind) {
        switch detectionKind {
        case .names:
            self = .names
        case .addresses:
            self = .addresses
        case .phoneNumbers:
            self = .phoneNumbers
        }
    }
}

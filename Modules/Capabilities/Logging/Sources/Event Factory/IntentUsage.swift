//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public enum IntentUsage {
    case addAutoRedactions
    case deleteAutoRedactions
    case getAutoRedactions
    case openImage
    case redactAuto
    case redactDetections
    case redactEverything
    case redactWords

    var value: String {
        switch self {
        case .addAutoRedactions: "addAutoRedactions"
        case .deleteAutoRedactions: "deleteAutoRedactions"
        case .getAutoRedactions: "getAutoRedactions"
        case .openImage: "openImage"
        case .redactAuto: "redactAuto"
        case .redactDetections: "redactDetections"
        case .redactEverything: "redactEverything"
        case .redactWords: "redactWords"
        }
    }
}

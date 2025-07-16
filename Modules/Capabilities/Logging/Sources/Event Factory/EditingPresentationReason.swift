//  Created by Geoff Pado on 1/31/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public enum EditorPresentationReason: PresentationReason {
    case appIntent
    case documentScanner
    case dragAndDrop
    case fileURL
    case library
    case photoPicker
    case stateRestoration
    case xCallbackURL

    var value: String {
        switch self {
        case .appIntent: "appIntent"
        case .stateRestoration: "stateRestoration"
        case .documentScanner: "documentScanner"
        case .dragAndDrop: "dragAndDrop"
        case .fileURL: "fileURL"
        case .library: "library"
        case .photoPicker: "photoPicker"
        case .xCallbackURL: "xCallbackURL"
        }
    }
}

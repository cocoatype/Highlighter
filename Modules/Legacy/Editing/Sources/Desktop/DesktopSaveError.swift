//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

enum DesktopSaveError: Error {
    case missingRepresentedURL
    case missingImageType
    case noImageData

    var alertTitle: String {
        switch self {
        case .missingRepresentedURL: return Strings.DesktopSaveError.missingRepresentedURLTitle
        case .missingImageType: return Strings.DesktopSaveError.missingImageTypeTitle
        case .noImageData: return Strings.DesktopSaveError.noImageDataTitle
        }
    }

    var alertMessage: String {
        return Strings.DesktopSaveError.alertMessage
    }
}

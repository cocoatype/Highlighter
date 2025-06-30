//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

enum DesktopSaveError: Error {
    case missingRepresentedURL
    case missingImageType
    case noImageData

    var alertTitle: String {
        switch self {
        case .missingRepresentedURL: return EditingStrings.DesktopSaveError.missingRepresentedURLTitle
        case .missingImageType: return EditingStrings.DesktopSaveError.missingImageTypeTitle
        case .noImageData: return EditingStrings.DesktopSaveError.noImageDataTitle
        }
    }

    var alertMessage: String {
        return EditingStrings.DesktopSaveError.alertMessage
    }
}

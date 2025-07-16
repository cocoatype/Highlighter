//  Created by Geoff Pado on 7/2/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit
import UniformTypeIdentifiers

import FactoryKit

import ErrorHandling

extension UIImage {
    var imageType: UTType? {
        guard let imageTypeString = cgImage?.utType
        else { return nil }

        return UTType(imageTypeString as String)
    }

    func encoded(as type: UTType) -> Data? {
        switch type {
        case .jpeg: return jpegData(compressionQuality: 0.75)
        case .heic:
            if #available(iOS 17, *) {
                return heicData()
            } else {
                Container.shared.errorHandler()
                    .log(
                        ExportingError.unexpectedHEIC,
                        module: "Exporting",
                        type: "UIImageExtensions"
                    )
                return jpegData(compressionQuality: 0.75)
            }
        default:
            Container.shared.errorHandler()
                .log(
                    ExportingError.unexpectedEncodeType(type.identifier),
                    module: "Exporting",
                    type: "UIImageExtensions"
                )
            return jpegData(compressionQuality: 0.75)
        }
    }
}

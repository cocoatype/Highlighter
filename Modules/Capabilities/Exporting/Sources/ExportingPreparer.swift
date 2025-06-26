//  Created by Geoff Pado on 7/12/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Photos
import Redactions
import Rendering
import UIKit
import UniformTypeIdentifiers

public class ExportingPreparer: NSObject {
    private let image: UIImage
    private let asset: PHAsset?
    private let redactions: [Redaction]

    public init(image: UIImage, asset: PHAsset?, redactions: [Redaction]) {
        self.image = image
        self.asset = asset
        self.redactions = redactions
    }

    public var preparedURL: URL {
        get async throws {
            let exportedImage = try await Rendering.renderer
                .render(image: image, redactions: redactions)

            let representedURLName = "\(ExportingStrings.PhotoEditingExporter.defaultImageName).\(imageType.preferredFilenameExtension ?? "png")"
            let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(representedURLName)

            let data: Data?

            switch imageType {
            case .jpeg:
                data = exportedImage.jpegData(compressionQuality: 0.9)
            default:
                data = exportedImage.pngData()
            }

            guard let data else { throw ExportingError.noDataGenerated }
            try data.write(to: temporaryURL)

            return temporaryURL
        }
    }

    var imageType: UTType {
        asset?.imageType ?? image.imageType ?? .png
    }
}

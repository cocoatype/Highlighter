//  Created by Geoff Pado on 9/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit
import UniformTypeIdentifiers

import FactoryKit

import ErrorHandling

struct PasteboardReader {
    @Injected(\.errorHandler) private var errorHandler
    func cacheBookmarkDataForPasteboardContents() -> Data? {
        let imageTypeIdentifier = UIPasteboard.general.types.first(where: { identifier in
            guard let type = UTType(identifier) else { return false }
            return type.conforms(to: .image)
        })
        guard let imageTypeIdentifier,
              let imageType = UTType(imageTypeIdentifier),
              let data = UIPasteboard.general.data(forPasteboardType: imageType.identifier)
        else { return nil }

        do {
            let cacheURL = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileURL = cacheURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(for: imageType)
            try data.write(to: fileURL)
            return try fileURL.bookmarkData()
        } catch {
            errorHandler.log(error, module: "Core", type: "PasteboardReader")
            return nil
        }
    }
}

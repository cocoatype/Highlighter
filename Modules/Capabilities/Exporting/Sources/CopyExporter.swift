//  Created by Geoff Pado on 7/12/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import Photos

import FactoryKit

import Defaults
import Logging
import Redactions

public final class CopyExporter: NSObject, Sendable {
    private let preparedURL: URL
    public convenience init(preparedURL: URL) {
        self.init(preparedURL: preparedURL, library: PHPhotoLibrary.shared())
    }

    private let library: any PhotoLibrary
    init(
        preparedURL: URL,
        library: any PhotoLibrary
    ) {
        self.preparedURL = preparedURL
        self.library = library
    }

    public func export() async throws {
        try await library.performChanges { [preparedURL] in
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: preparedURL)
        }

        await ExportRecorder.recordExport(style: .copy)
    }
}

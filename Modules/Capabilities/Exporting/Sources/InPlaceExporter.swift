//  Created by Geoff Pado on 7/12/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import Photos
import UIKit

import FactoryKit

import Defaults
import ErrorHandling
import Logging
import Redactions

public final class InPlaceExporter: NSObject, Sendable {
    public convenience init(
        preparedURL: URL,
        asset: PHAsset,
        redactions: [Redaction]
    ) {
        self.init(
            asset: asset,
            outputFactory: PhotoOutputFactory(preparedURL: preparedURL, redactions: redactions),
            library: PHPhotoLibrary.shared()
        )
    }

    private let asset: any ExportableAsset
    private let outputFactory: any OutputFactory
    private let errorHandler = Container.shared.errorHandler()
    private let library: any PhotoLibrary
    init(
        asset: any ExportableAsset,
        outputFactory: any OutputFactory,
        library: any PhotoLibrary
    ) {
        self.asset = asset
        self.outputFactory = outputFactory
        self.library = library
    }

    public func export() async throws {
        let (contentEditingInput, _) = await asset.requestContentEditingInput(with: nil)
        do {
            guard let contentEditingInput else { throw ExportingError.noInputProvided }

            let output = try outputFactory.output(from: contentEditingInput)

            try await library.performChanges { [asset] in
                asset.changeRequest.contentEditingOutput = output
            }

            await ExportRecorder.recordExport(style: .inPlace)
        } catch {
            errorHandler.log(error, module: "Exporting", type: "InPlaceExporter")
            throw error
        }
    }
}

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

public class InPlaceExporter: NSObject {
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
    @Injected(\.defaults) private var defaults
    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.logger) private var logger
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

            await defaults.set(defaults.value(for: Keys.numberOfSaves) + 1, for: Keys.numberOfSaves)
            await logger.log(ExportingEventFactory().event(style: .inPlace))
        } catch {
            errorHandler.log(error, module: "Exporting", type: "InPlaceExporter")
            throw error
        }
    }
}

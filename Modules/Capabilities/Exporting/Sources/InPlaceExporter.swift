//  Created by Geoff Pado on 7/12/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Defaults
import ErrorHandling
import Foundation
import Logging
import Photos
import Redactions
import UIKit

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
    private let defaults: any DefaultsProvider
    private let logger: any Logger
    private let library: any PhotoLibrary
    init(
        asset: any ExportableAsset,
        outputFactory: any OutputFactory,
        defaults: any DefaultsProvider = Defaults.provider,
        logger: any Logger = Logging.logger,
        library: any PhotoLibrary
    ) {
        self.asset = asset
        self.outputFactory = outputFactory
        self.defaults = defaults
        self.logger = logger
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
            ErrorHandler().log(error)
            throw error
        }
    }
}

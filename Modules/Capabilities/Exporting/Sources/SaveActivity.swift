//  Created by Geoff Pado on 7/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import ErrorHandling
import Geometry
import Redactions

class SaveActivity: UIActivity {
    private let asset: PHAsset
    private let redactions: [Redaction]
    init(asset: PHAsset, redactions: [Redaction]) {
        self.asset = asset
        self.redactions = redactions
    }

    override var activityTitle: String? {
        Strings.SaveActivity.title
    }

    override var activityImage: UIImage? {
        ExportingAsset.save.image
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return activityItems.count == 1 && activityItems.first is URL
    }

    private var activityURL: URL?
    override func prepare(withActivityItems activityItems: [Any]) {
        activityURL = activityItems.first as? URL
    }

    @Injected(\.errorHandler) private var errorHandler
    override func perform() {
        guard let activityURL else {
            return errorHandler.log(
                ExportingError.noActivityURL,
                module: "Exporting",
                type: "SaveActivity"
            )
        }

        Task { [weak self] in
            guard let self else { return }
            do {
                try await InPlaceExporter(
                    preparedURL: activityURL,
                    asset: asset,
                    redactions: redactions
                ).export()
                activityDidFinish(true)
            } catch {
                errorHandler.log(
                    error,
                    module: "Exporting",
                    type: "SaveActivity"
                )
                activityDidFinish(false)
            }
        }
    }
}

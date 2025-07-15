//  Created by Geoff Pado on 7/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import ErrorHandling

class SaveCopyActivity: UIActivity {
    override var activityTitle: String? {
        ExportingStrings.SaveCopyActivity.title
    }

    override var activityImage: UIImage? {
        ExportingAsset.saveCopy.image
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
            return errorHandler.log(ExportingError.noActivityURL)
        }

        Task {
            do {
                try await CopyExporter(preparedURL: activityURL).export()
            } catch {
                errorHandler.log(error)
            }
        }
    }
}

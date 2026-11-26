//  Created by Geoff Pado on 7/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import Exporting
import Redactions

public class ExportingActivityController: UIActivityViewController {
    public init(image: UIImage, asset: PHAsset?, redactions: [Redaction]) async throws {
        let preparer = ExportingPreparer(image: image, asset: asset, redactions: redactions)
        let temporaryURL = try await preparer.preparedURL
        super.init(activityItems: [temporaryURL], applicationActivities: Self.applicationActivities(asset: asset, redactions: redactions))
        excludedActivityTypes = [.saveToCameraRoll]
    }

    static func applicationActivities(asset: PHAsset?, redactions: [Redaction]) -> [UIActivity] {
        if let asset {
            [SaveActivity(asset: asset, redactions: redactions), SaveCopyActivity()]
        } else {
            [SaveCopyActivity()]
        }
    }
}

//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import Redactions
import UserActivities

/// Fills an `EditingUserActivity` with what's needed to restore the editor.
@MainActor
struct PhotoEditingUserActivityUpdater {
    let asset: PHAsset?
    let representedFileURL: URL?
    let image: UIImage?
    let redactions: [Redaction]

    func update(_ activity: EditingUserActivity) {
        if let asset {
            activity.assetLocalIdentifier = asset.localIdentifier
        } else if let representedFileURL {
            let accessGranted = representedFileURL.startAccessingSecurityScopedResource()
            defer { representedFileURL.stopAccessingSecurityScopedResource() }
            guard accessGranted else { return }

            activity.imageBookmarkData = try? representedFileURL.bookmarkData()
        } else if let image {
            activity.image = image
        }
        activity.redactions = redactions
    }
}

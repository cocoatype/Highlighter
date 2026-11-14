//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import UserActivities

@testable import Editing

@MainActor
struct PhotoEditingUserActivityUpdaterTests {
    @Test func updateStoresImageWhenThereIsNoAssetOrFile() {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4)).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
        }
        let activity = EditingUserActivity()

        PhotoEditingUserActivityUpdater(asset: nil, representedFileURL: nil, image: image, redactions: []).update(activity)

        #expect(activity.imageData != nil)
        #expect(activity.assetLocalIdentifier == nil)
        #expect(activity.imageBookmarkData == nil)
        #expect(activity.redactions?.isEmpty == true)
    }

    @Test func updateStoresRedactionsWithoutAnySource() {
        let activity = EditingUserActivity()

        PhotoEditingUserActivityUpdater(asset: nil, representedFileURL: nil, image: nil, redactions: []).update(activity)

        #expect(activity.imageData == nil)
        #expect(activity.redactions?.isEmpty == true)
    }
}

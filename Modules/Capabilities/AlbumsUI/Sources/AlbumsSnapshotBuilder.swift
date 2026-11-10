//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import AlbumsData
import UIKit

enum AlbumsSnapshotBuilder {
    /// Builds a snapshot keyed by section title and collection identifier, skipping any
    /// duplicate identifiers (which diffable data sources do not allow).
    static func snapshot(from sections: [PhotoCollectionSection]) -> NSDiffableDataSourceSnapshot<String, String> {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        var seenSections = Set<String>()
        var seenItems = Set<String>()

        for section in sections where seenSections.insert(section.title).inserted {
            snapshot.appendSections([section.title])
            let identifiers = section.collections
                .map(\.identifier)
                .filter { seenItems.insert($0).inserted }
            snapshot.appendItems(identifiers, toSection: section.title)
        }

        return snapshot
    }
}

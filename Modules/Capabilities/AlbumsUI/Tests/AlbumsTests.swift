//  Created by Geoff Pado on 7/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AlbumsData
import Photos
import Testing
import UIKit

@testable import AlbumsUI

struct AlbumsSnapshotBuilderTests {
    private struct DummyCollection: PhotoCollection {
        let title: String?
        let icon = "photo"
        let identifier: String
        var assets: PHFetchResult<PHAsset> { .init() }

        init(_ identifier: String) {
            self.title = identifier
            self.identifier = identifier
        }
    }

    @Test
    func sectionsAndItemsInOrder() {
        let snapshot = AlbumsSnapshotBuilder.snapshot(from: [
            PhotoCollectionSection(title: "Smart", collections: [DummyCollection("recents"), DummyCollection("screenshots")]),
            PhotoCollectionSection(title: "User", collections: [DummyCollection("vacation")]),
        ])

        #expect(snapshot.sectionIdentifiers == ["Smart", "User"])
        #expect(snapshot.itemIdentifiers(inSection: "Smart") == ["recents", "screenshots"])
        #expect(snapshot.itemIdentifiers(inSection: "User") == ["vacation"])
    }

    @Test
    func emptySectionIsKept() {
        let snapshot = AlbumsSnapshotBuilder.snapshot(from: [
            PhotoCollectionSection(title: "User", collections: []),
        ])

        #expect(snapshot.sectionIdentifiers == ["User"])
        #expect(snapshot.numberOfItems == 0)
    }

    @Test
    func duplicateIdentifiersAreSkipped() {
        let snapshot = AlbumsSnapshotBuilder.snapshot(from: [
            PhotoCollectionSection(title: "Smart", collections: [DummyCollection("a"), DummyCollection("a")]),
            PhotoCollectionSection(title: "Smart", collections: [DummyCollection("b")]),
            PhotoCollectionSection(title: "User", collections: [DummyCollection("a"), DummyCollection("c")]),
        ])

        #expect(snapshot.sectionIdentifiers == ["Smart", "User"])
        #expect(snapshot.itemIdentifiers(inSection: "Smart") == ["a"])
        #expect(snapshot.itemIdentifiers(inSection: "User") == ["c"])
    }
}

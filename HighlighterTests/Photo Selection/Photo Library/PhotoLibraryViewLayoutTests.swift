//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

@testable import Highlighter
import XCTest

class PhotoLibraryViewLayoutTests: XCTestCase {
    func testHorizontallyCompactPhonesHaveNoSideMargins() {
        let libraryView = MockPhotoLibraryView()
        libraryView.horizontalSizeClass = .compact
        libraryView.userInterfaceIdiom = .phone

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        XCTAssertEqual(layout.sectionInset.left, 0)
        XCTAssertEqual(layout.sectionInset.left, layout.sectionInset.right)
    }

    func testHorizontallyRegularPhonesHaveNoSideMargins() {
        let libraryView = MockPhotoLibraryView()
        libraryView.horizontalSizeClass = .regular
        libraryView.userInterfaceIdiom = .phone

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        XCTAssertEqual(layout.sectionInset.left, 0)
        XCTAssertEqual(layout.sectionInset.left, layout.sectionInset.right)
    }

    func testHorizontallyCompactPadsHaveNoSideMargins() {
        let libraryView = MockPhotoLibraryView()
        libraryView.horizontalSizeClass = .compact
        libraryView.userInterfaceIdiom = .pad

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        XCTAssertEqual(layout.sectionInset.left, 0)
        XCTAssertEqual(layout.sectionInset.left, layout.sectionInset.right)
    }

    func testHorizontallyRegularPadsHaveSideMargins() {
        let libraryView = MockPhotoLibraryView()
        libraryView.horizontalSizeClass = .regular
        libraryView.userInterfaceIdiom = .pad

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        XCTAssertEqual(layout.sectionInset.left, 15)
        XCTAssertEqual(layout.sectionInset.left, layout.sectionInset.right)
    }

    func testThinHorizontallyCompactItemSize() {
        let libraryView = MockPhotoLibraryView()
        libraryView.bounds = CGRect(x: 0, y: 0, width: 450, height: 0)
        libraryView.horizontalSizeClass = .compact

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        let contentWidth = libraryView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        let itemWidth = layout.itemSize.width
        let numberOfItems = contentWidth / itemWidth

        XCTAssert(((numberOfItems + 1) * itemWidth) > contentWidth)
    }

    func testThickHorizontallyCompactItemSize() {
        let libraryView = MockPhotoLibraryView()
        libraryView.bounds = CGRect(x: 0, y: 0, width: 550, height: 0)
        libraryView.horizontalSizeClass = .compact

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        let contentWidth = libraryView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        let itemWidth = layout.itemSize.width
        let numberOfItems = contentWidth / itemWidth

        XCTAssert(((numberOfItems + 1) * itemWidth) > contentWidth)
    }

    func testThinHorizontallyRegularItemSize() {
        let libraryView = MockPhotoLibraryView()
        libraryView.bounds = CGRect(x: 0, y: 0, width: 450, height: 0)
        libraryView.horizontalSizeClass = .regular

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        let contentWidth = libraryView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        let itemWidth = layout.itemSize.width
        let numberOfItems = contentWidth / itemWidth

        XCTAssert(((numberOfItems + 1) * itemWidth) > contentWidth)
    }

    func testThickHorizontallyRegularItemSize() {
        let libraryView = MockPhotoLibraryView()
        libraryView.bounds = CGRect(x: 0, y: 0, width: 750, height: 0)
        libraryView.horizontalSizeClass = .regular

        let layout = MockPhotoLibraryViewLayout()
        layout.overrideCollectionView = libraryView
        layout.prepare()

        let contentWidth = libraryView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        let itemWidth = layout.itemSize.width
        let numberOfItems = contentWidth / itemWidth

        XCTAssert(((numberOfItems + 1) * itemWidth) > contentWidth)
    }
}

private class MockPhotoLibraryViewLayout: PhotoLibraryViewLayout {
    var overrideCollectionView: UICollectionView?

    override var collectionView: UICollectionView? {
        return overrideCollectionView
    }
}

private class MockPhotoLibraryView: PhotoLibraryView {
    var horizontalSizeClass = UIUserInterfaceSizeClass.unspecified
    var userInterfaceIdiom = UIUserInterfaceIdiom.unspecified

    override var traitCollection: UITraitCollection {
        let traitCollection = MockTraitCollection()
        traitCollection.overrideHorizontalSizeClass = horizontalSizeClass
        traitCollection.overrideUserInterfaceIdiom = userInterfaceIdiom
        return traitCollection
    }
}

private class MockTraitCollection: UITraitCollection {
    var overrideHorizontalSizeClass = UIUserInterfaceSizeClass.unspecified
    var overrideUserInterfaceIdiom = UIUserInterfaceIdiom.unspecified

    override var horizontalSizeClass: UIUserInterfaceSizeClass {
        return overrideHorizontalSizeClass
    }

    override var userInterfaceIdiom: UIUserInterfaceIdiom {
        return overrideUserInterfaceIdiom
    }
}

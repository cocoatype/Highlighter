//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

@testable import Highlighter
import XCTest

class PhotoLibraryViewLayoutTests: XCTestCase {}

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

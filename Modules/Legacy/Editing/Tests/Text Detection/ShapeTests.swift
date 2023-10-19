//  Created by Geoff Pado on 10/19/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Editing

final class ShapeTests: XCTestCase {
    func testIsNotEmptyReturnsFalseForEmptyShape() {
        XCTAssertFalse(TestHelpers.emptyShape.isNotEmpty)
    }

    func testIsNotEmptyReturnsTrueForNonEmptyShape() {
        XCTAssertTrue(TestHelpers.shape.isNotEmpty)
    }
}

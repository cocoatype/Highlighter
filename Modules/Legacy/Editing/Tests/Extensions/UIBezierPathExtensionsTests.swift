//  Created by Geoff Pado on 10/19/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Editing

final class UIBezierPathExtensionsTests: XCTestCase {
    func testCreatingShape() throws {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 0))
        path.close()

        let shape = try XCTUnwrap(path.shape)
        XCTAssertEqual(shape, TestHelpers.shape)
    }
}

//  Created by Geoff Pado on 10/19/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Geometry
import XCTest

@testable import Observations
@testable import Redactions

final class UIBezierPathExtensionsTests: XCTestCase {
    func testCreatingShape() throws {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 0))
        path.close()

        let shape = try XCTUnwrap(path.shape)
        XCTAssertEqual(shape, Shape.sample)
    }

    func testCreatingShapeIgnoresCurvesAndUsesFirstFourPoints() throws {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: 9, y: 9), controlPoint1: CGPoint(x: 7, y: 7), controlPoint2: CGPoint(x: 8, y: 8))
        path.addLine(to: CGPoint(x: 0, y: 5))
        path.addQuadCurve(to: CGPoint(x: 9, y: 9), controlPoint: CGPoint(x: 7, y: 7))
        path.close()
        path.move(to: CGPoint(x: 5, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 20))
        path.close()

        let shape = try XCTUnwrap(path.shape)
        XCTAssertEqual(shape, Shape.sample)
    }
}

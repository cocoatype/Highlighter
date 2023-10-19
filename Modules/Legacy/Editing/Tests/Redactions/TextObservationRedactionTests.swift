//  Created by Geoff Pado on 10/19/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Editing

final class TextObservationRedactionTests: XCTestCase {
#if canImport(UIKit)
    func testInitIgnoresEmptyShapes() throws {
        let observation = MockTextObservation(bounds: TestHelpers.emptyShape)
        let redaction = Redaction(observation, color: .black)

        XCTAssertEqual(redaction.parts.count, 0)
    }

    func testInitIncludesNonEmptyShapes() throws {
        let observation = MockTextObservation(bounds: TestHelpers.shape)
        let redaction = Redaction(observation, color: .black)

        XCTAssertEqual(redaction.parts.count, 1)
    }
#endif
}

private struct MockTextObservation: TextObservation {
    let bounds: Shape
}

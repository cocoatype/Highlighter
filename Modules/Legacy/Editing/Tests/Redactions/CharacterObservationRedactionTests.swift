//  Created by Geoff Pado on 10/19/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Editing

final class CharacterObservationRedactionTests: XCTestCase {
    #if canImport(UIKit)
    func testInitIgnoresEmptyShapes() throws {
        let observation = CharacterObservation(bounds: TestHelpers.emptyShape, textObservationUUID: UUID())
        let redaction = try XCTUnwrap(Redaction([observation], color: .black))

        XCTAssertEqual(redaction.parts.count, 0)
    }

    func testInitIncludesNonEmptyShapes() throws {
        let observation = CharacterObservation(bounds: TestHelpers.shape, textObservationUUID: UUID())
        let redaction = try XCTUnwrap(Redaction([observation], color: .black))

        XCTAssertEqual(redaction.parts.count, 1)
    }
    #endif
}

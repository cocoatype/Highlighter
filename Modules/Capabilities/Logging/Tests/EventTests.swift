//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import XCTest
@testable import Logging

final class EventTests: XCTestCase {
    func testNameInitWithValue() {
        let event = Event(
            name: Event.Name("static"),
            info: [:]
        )

        XCTAssertEqual(event.value, "static")
    }

    func testNameInitWithLiteral() {
        let event = Event(
            name: "literal",
            info: [:]
        )

        XCTAssertEqual(event.value, "literal")
    }

    func testInfoInit() {
        let event = Event(name: "", info: ["key": "value"])
        XCTAssertEqual(event.info, ["key": "value"])
    }
}

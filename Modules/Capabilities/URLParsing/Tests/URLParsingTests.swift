//  Created by Geoff Pado on 7/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import URLParsing

class URLParsingTests: XCTestCase {
    func testParsingCallbackImageURL() throws {
        let url = try CallbackActionURLGenerator().openURL(imageURL: imageURL)
        let result = URLParser().parse(url)
        XCTAssert(result.isCallbackAction)
    }

    func testParsingImageURL() throws {
        let result = try URLParser().parse(imageURL)
        let actualURL = try XCTUnwrap(result.imageURL)

        try XCTAssertEqual(actualURL, imageURL)
    }

    func testParsingWebURL() throws {
        let url = try XCTUnwrap(URL(string: "highlighter://blackhighlighter.app/releases"))
        let expectedWebURL = try XCTUnwrap(URL(string: "https://blackhighlighter.app/releases"))
        let actualWebURL = try XCTUnwrap(URLParser().parse(url).webURL)

        XCTAssertEqual(actualWebURL, expectedWebURL)
    }

    func testParsingInvalidFileURL() throws {
        let url = try XCTUnwrap(URL(string: "https://cocoatype.com/"))
        let result = URLParser().parse(url)

        XCTAssert(result.isInvalid)
    }
}

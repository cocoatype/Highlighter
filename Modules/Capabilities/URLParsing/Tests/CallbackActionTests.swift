//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import URLParsing

class CallbackActionTests: XCTestCase {
    #if canImport(UIKit)
    func testCreatingOpenAction() throws {
        let url = try CallbackActionURLGenerator().openURL(imageURL: imageURL)
        let expectedImage = try XCTUnwrap(UIImage(contentsOfFile: imageURL.path))
        let action = try XCTUnwrap(CallbackAction(url: url))
        XCTAssert(action.isOpen)
        XCTAssertEqual(action.image.size, expectedImage.size)
    }

    func testCreatingEditActionWithoutCallback() throws {
        let url = try CallbackActionURLGenerator().editURL(imageURL: imageURL, successURL: nil)
        let expectedImage = try XCTUnwrap(UIImage(contentsOfFile: imageURL.path))
        let action = try XCTUnwrap(CallbackAction(url: url))
        XCTAssert(action.isEdit)
        XCTAssertNil(action.callbackURL)
        XCTAssertEqual(action.image.size, expectedImage.size)
    }

    func testCreatingEditActionWithCallback() throws {
        let successURL = try XCTUnwrap(URL(string: "https://blackhiglighter.app"))
        let expectedImage = try XCTUnwrap(UIImage(contentsOfFile: imageURL.path))
        let url = try CallbackActionURLGenerator().editURL(imageURL: imageURL, successURL: successURL)
        let action = try XCTUnwrap(CallbackAction(url: url))
        XCTAssert(action.isEdit)
        XCTAssertEqual(action.callbackURL, successURL)
        XCTAssertEqual(action.image.size, expectedImage.size)
    }

    func testCreatingNonCallbackAction() throws {
        let url = try XCTUnwrap(URL(string: "highlighter://bad-host/"))
        let action = CallbackAction(url: url)
        XCTAssertNil(action)
    }

    func testCreatingInvalidCallbackAction() throws {
        let url = try CallbackActionURLGenerator().url(action: "bad-action", imageURL: imageURL, successURL: nil)
        let action = CallbackAction(url: url)
        XCTAssertNil(action)
    }
    #endif
}

extension CallbackAction {
    #if canImport(UIKit)
    var isEdit: Bool {
        switch self {
        case .edit: true
        case .open: false
        }
    }

    var isOpen: Bool {
        switch self {
        case .open: true
        case .edit: false
        }
    }

    var callbackURL: URL? {
        switch self {
        case .edit(_, let url): url
        case .open: nil
        }
    }
    #endif
}

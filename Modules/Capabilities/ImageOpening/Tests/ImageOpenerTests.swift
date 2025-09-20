//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing
import UIKit

@testable import ImageOpening

struct ImageOpenerTests {
    static var imageData: Data {
        get throws {
            let image = try #require(UIImage(systemName: "bolt"))
            return try #require(image.pngData())
        }
    }

    @Test
    func `openImage succeeds if not secure`() throws {
        let resource = try SpySecureResource(
            dataResult: .success(Self.imageData),
            isSecure: false
        )
        _ = try ImageOpener().openImage(resource: resource)
        #expect(resource.startAccessingCalled)
        #expect(resource.stopAccessingCalled)
    }

    @Test
    func `openImage fails if data errors and not secure`() throws {
        let resource = SpySecureResource(
            dataResult: .failure(TestError.sample),
            isSecure: false
        )

        #expect(throws: TestError.sample) {
            _ = try ImageOpener().openImage(resource: resource)
        }
        #expect(resource.startAccessingCalled)
        #expect(resource.stopAccessingCalled)
    }

    @Test
    func `openImage succeeds if secure`() throws {
        let resource = try SpySecureResource(
            dataResult: .success(Self.imageData),
            isSecure: true
        )

        _ = try ImageOpener().openImage(resource: resource)
        #expect(resource.startAccessingCalled)
        #expect(resource.stopAccessingCalled)
    }

    @Test
    func `openImage fails if data errors and secure`() throws {
        let resource = SpySecureResource(
            dataResult: .failure(TestError.sample),
            isSecure: true
        )

        #expect(throws: TestError.sample) {
            _ = try ImageOpener().openImage(resource: resource)
        }
        #expect(resource.startAccessingCalled)
        #expect(resource.stopAccessingCalled)
    }

    enum TestError: Error {
        case sample
    }
}

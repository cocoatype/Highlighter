//  Created by Geoff Pado on 9/19/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

struct SpySecureResourceTests {
    @Test func `data fails if start not called`() throws {
        let resource = SpySecureResource(
            dataResult: .failure(TestError.sample),
            isSecure: true
        )

        #expect(throws: SpySecureResource.Error.startNotCalled) {
            _ = try resource.data
        }
    }

    @Test func `data fails if stop called early`() throws {
        let resource = SpySecureResource(
            dataResult: .failure(TestError.sample),
            isSecure: true
        )

        _ = resource.startAccessingSecurityScopedResource()
        resource.stopAccessingSecurityScopedResource()

        #expect(throws: SpySecureResource.Error.stopAlreadyCalled) {
            _ = try resource.data
        }
    }

    @Test func `startAccessing returns true if secure`() throws {
        let resource = SpySecureResource(
            dataResult: .failure(TestError.sample),
            isSecure: true
        )

        #expect(resource.startAccessingSecurityScopedResource() == true)
    }

    @Test func `startAccessing returns false if not secure`() throws {
        let resource = SpySecureResource(
            dataResult: .failure(TestError.sample),
            isSecure: false
        )

        #expect(resource.startAccessingSecurityScopedResource() == false)
    }

    enum TestError: Error {
        case sample
    }
}

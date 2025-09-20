//  Created by Geoff Pado on 9/19/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

@testable import ImageOpening

class SpySecureResource: SecureResource {
    private let dataResult: Result<Data, Swift.Error>
    private let isSecure: Bool

    init(
        dataResult: Result<Data, Swift.Error>,
        isSecure: Bool,
    ) {
        self.dataResult = dataResult
        self.isSecure = isSecure
    }

    private(set) var startAccessingCalled = false
    func startAccessingSecurityScopedResource() -> Bool {
        startAccessingCalled = true
        return isSecure
    }

    private(set) var stopAccessingCalled = false
    func stopAccessingSecurityScopedResource() {
        stopAccessingCalled = true
    }

    var data: Data {
        get throws {
            guard isSecure else { return try dataResult.get() }

            guard startAccessingCalled else { throw Error.startNotCalled }
            guard stopAccessingCalled == false else { throw Error.stopAlreadyCalled }

            return try dataResult.get()
        }
    }

    enum Error: Swift.Error {
        case startNotCalled
        case stopAlreadyCalled
    }
}

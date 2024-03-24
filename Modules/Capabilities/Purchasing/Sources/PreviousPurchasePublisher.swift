//  Created by Geoff Pado on 5/21/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import ErrorHandling
import Receipts

public struct PreviousPurchasePublisher: Publisher {
    public typealias Output = Bool
    public typealias Failure = Error

    public init() {
        self.init(verifier: PurchaseVerifier())
    }

    private let verifier: Verifier
    init(verifier: Verifier) {
        self.verifier = verifier
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        Task {
            let result = await Result { await verifier.hasUserPurchased }
            Result.Publisher(result).subscribe(subscriber)
        }
    }
}

extension Result where Failure == Error {
    init(catching body: () async throws -> Success) async {
        do {
            let success = try await body()
            self = .success(success)
        } catch {
            self = .failure(error)
        }
    }
}

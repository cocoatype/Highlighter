//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Synchronization

import Logging
import TestHelpersInterface

@available(iOS 18.0, *)
public final class SpyLogger: Logger {
    public init(
        logExpectation: Expectation? = nil
    ) {
        self.logExpectation = logExpectation
    }

    private let _loggedEvents = Mutex([Event]())
    private(set) public var loggedEvents: [Event] {
        get {
            _loggedEvents.withLock { $0 }
        }
        set {
            _loggedEvents.withLock { $0 = newValue }
        }
    }

    public let logExpectation: Expectation?
    public func log(_ event: Event) {
        loggedEvents.append(event)
    }
}

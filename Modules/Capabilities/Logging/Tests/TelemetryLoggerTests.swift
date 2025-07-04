//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Synchronization
import Testing

import TelemetryClient

@testable import Logging

struct TelemetryLoggerTests {
    @Test func bareInitInitializesTelemetryManager() {
        #expect(TelemetryManager.isInitialized == false)

        _ = TelemetryLogger()

        #expect(TelemetryManager.isInitialized == true)
    }

    @available(iOS 18, *)
    @Test func logSendsEventNameAndInfo() throws {
        let signaledName = Mutex<String?>(nil)
        let signaledInfo = Mutex<[String: String]?>(nil)
        let logger = TelemetryLogger { name, parameters, _, _ in
            signaledName.withLock { $0 = name }
            signaledInfo.withLock { $0 = parameters }
        }

        logger.log(Event(name: "test", info: ["key": "value"]))

        let spyName = try #require(signaledName.withLock { $0 })
        let spyInfo = try #require(signaledInfo.withLock { $0 })
        #expect(spyName == "test")
        #expect(spyInfo == ["key": "value"])
    }
}

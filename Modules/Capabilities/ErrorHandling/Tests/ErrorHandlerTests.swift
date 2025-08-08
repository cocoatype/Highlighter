//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

import FactoryKit
import FactoryTesting

import LoggingDoubles

@testable import ErrorHandling
@testable import Logging

@Suite(.container)
struct DefaultHandlerTests {
    @Test @available(iOS 18.0, *)
    func loggingSwiftErrorLogsDescription() throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        let handler = DefaultHandler()

        handler.log(SampleError.sample, module: "ErrorHandlingTests", type: "DefaultHandlerTests")
        let event = try #require(logger.loggedEvents.first)

        #expect(event.value == "TelemetryDeck.Error.occurred")
        #expect(event.info["TelemetryDeck.Error.id"] == "SampleError.sample")
        #expect(event.info["Highlighter.Error.module"] == "ErrorHandlingTests")
        #expect(event.info["Highlighter.Error.type"] == "DefaultHandlerTests")
    }

    @Test @available(iOS 18.0, *)
    func loggingNSErrorLogsInformation() throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        let handler = DefaultHandler()
        let error = NSError(domain: "sample", code: 19)

        handler.log(error, module: "ErrorHandlingTests", type: "DefaultHandlerTests")
        let event = try #require(logger.loggedEvents.first)

        #expect(event.value == "TelemetryDeck.Error.occurred")
        #expect(event.info["TelemetryDeck.Error.id"] == "sample - 19")
        #expect(event.info["Highlighter.Error.description"] == "The operation couldn’t be completed. (sample error 19.)")
        #expect(event.info["Highlighter.Error.module"] == "ErrorHandlingTests")
        #expect(event.info["Highlighter.Error.type"] == "DefaultHandlerTests")
    }

#if compiler(>=6.2) && os(macOS)
    @Test func crashingLogsMessage() async throws {
        await #expect(processExitsWith: .failure) {
            let logger = SpyLogger()
            Container.shared.logger.register { logger }
            let handler = DefaultHandler { _ in
                let event = logger.loggedEvents.first
                #expect(event?.value == "crash")
                #expect(event?.info == ["message": "crash"])
            }
            handler.crash("crash")
        }
    }

    @Test func notImplementedLogsMessage() async {
        await #expect(processExitsWith: .failure) {
            let logger = SpyLogger()
            Container.shared.logger.register { logger }
            let handler = DefaultHandler { message in
                let event = logger.loggedEvents.first
                #expect(event?.value == "notImplemented")
                #expect(event?.info["file"] == #fileID)
                #expect(event?.info["function"] == #function)
                #expect(message == "Unimplemented function")
            }
            handler.notImplemented()
        }
    }
#endif
}

private enum SampleError: Error {
    case sample
}

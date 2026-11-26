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
    @Test @available(iOS 18.0, macOS 15.0, *)
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

    @Test @available(iOS 18.0, macOS 15.0, *)
    func loggingNSErrorLogsInformation() throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        let handler = DefaultHandler()
        let error = NSError(domain: "sample", code: 19)

        handler.log(error, module: "ErrorHandlingTests", type: "DefaultHandlerTests")
        let event = try #require(logger.loggedEvents.first)

        #expect(event.value == "TelemetryDeck.Error.occurred")
        #expect(event.info["TelemetryDeck.Error.id"] == "sample - 19")
        #expect(event.info["Highlighter.Error.description"] == nil)
        #expect(event.info["Highlighter.Error.module"] == "ErrorHandlingTests")
        #expect(event.info["Highlighter.Error.type"] == "DefaultHandlerTests")
    }

    @Test func errorIDOmitsAssociatedValues() {
        let error = SampleError.withDetails(path: "/private/var/mobile/IMG_1234.jpg")
        #expect(DefaultHandler.errorID(for: error) == "SampleError.withDetails")
    }

    @Test func errorIDIncludesWrappedNSError() {
        let error = SampleError.wrapping(NSError(domain: "sample", code: 19, userInfo: [
            NSURLErrorFailingURLStringErrorKey: "https://example.com/?guid=secret",
        ]))
        #expect(DefaultHandler.errorID(for: error) == "SampleError.wrapping(sample - 19)")
    }

    @Test func errorIDIncludesWrappedURLError() {
        let error = SampleError.wrapping(URLError(.notConnectedToInternet, userInfo: [
            NSURLErrorFailingURLStringErrorKey: "https://example.com/?guid=secret",
        ]))
        #expect(DefaultHandler.errorID(for: error) == "SampleError.wrapping(NSURLErrorDomain - -1009)")
    }

    @Test func errorIDIncludesWrappedSwiftError() {
        let error = SampleError.labeledWrapping(label: "secret", error: SampleError.sample)
        #expect(DefaultHandler.errorID(for: error) == "SampleError.labeledWrapping(SampleError.sample)")
    }

#if compiler(>=6.2) && os(macOS)
    @Test @available(iOS 18.0, macOS 15.0, *)
    func crashingLogsMessage() async throws {
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

    @Test @available(iOS 18.0, macOS 15.0, *)
    func notImplementedLogsMessage() async {
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
    case withDetails(path: String)
    case wrapping(any Error)
    case labeledWrapping(label: String, error: any Error)
}

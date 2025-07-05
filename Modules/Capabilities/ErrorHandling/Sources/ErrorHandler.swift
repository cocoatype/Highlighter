//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import LoggingMac
#else
import Logging
#endif

public struct ErrorHandler: ErrorHandling {
    @Injected(\.logger) private var logger
    private var onExit: @Sendable (String) -> Void

    public init() {
        self.init(onExit: {_ in})
    }

    init(onExit: @escaping @Sendable (String) -> Void) {
        self.onExit = onExit
    }

    public func log(_ error: Error) {
        let errorID: String
        if type(of: error) is NSError.Type {
            let nsError = error as NSError
            errorID = "\(nsError.domain) - \(nsError.code)"
        } else {
            errorID = String(describing: error)
        }

        logger.log(Event(name: Self.logError, info: [
            Self.telemetryErrorIDKey: errorID,
            Self.errorDescriptionKey: error.localizedDescription,
        ]))
    }

    public func crash(_ message: String) -> Never {
        logger.log(Event(name: Self.crash, info: ["message": message]))
        onExit(message)
        fatalError(message)
    }

    public func notImplemented(file: String = #fileID, function: String = #function) -> Never {
        logger.log(Event(name: Self.notImplemented, info: ["file": file, "function": function]))
        onExit("Unimplemented function")
        fatalError("Unimplemented function")
    }

    // MARK: Event Names

    private static let logError = Event.Name("TelemetryDeck.Error.occurred")
    private static let crash = Event.Name("crash")
    private static let notImplemented = Event.Name("notImplemented")

    // MARK: Event Keys

    private static let errorDescriptionKey = "errorDescription"
    private static let telemetryErrorIDKey = "TelemetryDeck.Error.id"
}

@objc(ErrorHandling)
class ErrorHandlingObjC: NSObject {}

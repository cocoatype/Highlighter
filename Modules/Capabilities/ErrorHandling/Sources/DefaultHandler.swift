//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import LoggingMac
#else
import Logging
#endif

struct DefaultHandler: ErrorHandler {
    @Injected(\.logger) private var logger
    private var onExit: @Sendable (String) -> Void

    init() {
        self.init(onExit: {_ in})
    }

    init(onExit: @escaping @Sendable (String) -> Void) {
        self.onExit = onExit
    }

    func log(_ error: any Error, module: StaticString, type: StaticString) {
        let errorID: String
        if Swift.type(of: error) is NSError.Type {
            let nsError = error as NSError
            errorID = "\(nsError.domain) - \(nsError.code)"
        } else {
            errorID = String(describing: error)
        }

        logger.log(Event(name: Self.logError, info: [
            Self.telemetryErrorIDKey: errorID,
            Self.errorDescriptionKey: error.localizedDescription,
            Self.errorModuleKey: String(module),
            Self.errorTypeKey: String(type)
        ]))
    }

    func crash(_ message: String) -> Never {
        logger.log(Event(name: Self.crash, info: ["message": message]))
        onExit(message)
        fatalError(message)
    }

    func notImplemented(in file: String, function: String) -> Never {
        logger.log(Event(name: Self.notImplemented, info: ["file": file, "function": function]))
        onExit("Unimplemented function")
        fatalError("Unimplemented function")
    }

    // MARK: Event Names

    private static let logError = Event.Name("TelemetryDeck.Error.occurred")
    private static let crash = Event.Name("crash")
    private static let notImplemented = Event.Name("notImplemented")

    // MARK: Event Keys

    private static let errorModuleKey = "Highlighter.Error.module"
    private static let errorTypeKey = "Highlighter.Error.type"
    private static let errorDescriptionKey = "Highlighter.Error.description"
    private static let telemetryErrorIDKey = "TelemetryDeck.Error.id"
}

extension String {
    init(_ staticString: StaticString) {
        let buffer = staticString.withUTF8Buffer { $0 }
        self.init(decoding: buffer, as: UTF8.self)
    }
}

@objc(ErrorHandling)
class ErrorHandlingObjC: NSObject {}

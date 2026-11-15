//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

import Logging

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
        logger.log(Event(name: Self.logError, info: [
            Self.telemetryErrorIDKey: Self.errorID(for: error),
            Self.errorModuleKey: String(module),
            Self.errorTypeKey: String(type),
        ]))
    }

    /// An identifier for `error` built only from type names, case names, and
    /// error domains and codes. Associated values and user info can carry user
    /// details (file names, URLs, device identifiers), so they are never
    /// included, except that a wrapped error contributes its own identifier.
    static func errorID(for error: any Error) -> String {
        let mirror = Mirror(reflecting: error)
        guard mirror.displayStyle == .enum else {
            let nsError = error as NSError
            return "\(nsError.domain) - \(nsError.code)"
        }

        let errorType = String(describing: Swift.type(of: error))
        guard let payload = mirror.children.first else {
            return "\(errorType).\(error)"
        }

        let caseName = payload.label ?? "unknown"
        guard let wrappedError = wrappedError(in: payload.value) else {
            return "\(errorType).\(caseName)"
        }

        return "\(errorType).\(caseName)(\(errorID(for: wrappedError)))"
    }

    private static func wrappedError(in payload: Any) -> (any Error)? {
        if let error = payload as? any Error { return error }
        return Mirror(reflecting: payload).children.lazy.compactMap { $0.value as? any Error }.first
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

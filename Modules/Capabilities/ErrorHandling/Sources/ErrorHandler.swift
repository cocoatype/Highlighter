//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import Foundation
import Logging

public struct ErrorHandler: ErrorHandling {
    private var logger: Logger
    private var exit: (String) -> Never

    public init(logger: Logger) {
        self.init(logger: logger, exit: { fatalError($0) })
    }

    public init() {
        self.init(logger: TelemetryLogger())
    }

    init(logger: Logger, exit: @escaping (String) -> Never) {
        self.logger = logger
        self.exit = exit
    }

    public func log(_ error: Error) {
        let errorDescription: String
        if type(of: error) is NSError.Type {
            let nsError = error as NSError
            errorDescription = "\(nsError.domain) - \(nsError.code): \(nsError.localizedDescription)"
        } else {
            errorDescription = String(describing: error)
        }

        logger.log(Event(name: Self.logError, info: ["errorDescription": errorDescription]))
    }

    public func crash(_ message: String) -> Never {
        logger.log(Event(name: Self.crash, info: ["message": message]))
        return exit(message)
    }

    public func notImplemented(file: String = #fileID, function: String = #function) -> Never {
        logger.log(Event(name: Self.notImplemented, info: ["file": file, "function": function]))
        return exit("Unimplemented function")
    }

    // MARK: Event Names

    private static let logError = Event.Name("logError")
    private static let crash = Event.Name("crash")
    private static let notImplemented = Event.Name("notImplemented")
}

@objc(ErrorHandling)
class ErrorHandlingObjC: NSObject {}

//  Created by Geoff Pado on 5/16/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation
import Logging

public enum ErrorHandling {
    public static var logger: Logger = TelemetryLogger()

    public static func log(_ error: Error) {
        let errorDescription: String
        if type(of: error) is NSError.Type {
            let nsError = error as NSError
            errorDescription = "\(nsError.domain) - \(nsError.code): \(nsError.localizedDescription)"
        } else {
            errorDescription = String(describing: error)
        }

        logger.log(Event(name: logError, info: ["errorDescription": errorDescription]))
    }

    public static func crash(_ message: String) -> Never {
        logger.log(Event(name: crash, info: ["message": message]))
        return fatalError(message)
    }

    public static func notImplemented(file: String = #fileID, function: String = #function) -> Never {
        logger.log(Event(name: notImplemented, info: ["file": file, "function": function]))
        return fatalError("Unimplemented function")
    }

    // MARK: Event Names

    private static let logError = Event.Name("logError")
    private static let crash = Event.Name("crash")
    private static let notImplemented = Event.Name("notImplemented")
}

@objc(ErrorHandling)
class ErrorHandlingObjC: NSObject {}

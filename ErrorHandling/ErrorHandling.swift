//  Created by Geoff Pado on 5/16/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation
import TelemetryClient

public enum ErrorHandling {
    public static func setup() {
        let configuration = TelemetryManagerConfiguration(appID: "2B12B0C1-2C32-414A-BAB4-B20E866EC277")
        TelemetryManager.initialize(with: configuration)
    }

    public static func log(_ error: Error) {
        let errorDescription: String
        if type(of: error) is NSError.Type {
            let nsError = error as NSError
            errorDescription = "\(nsError.domain) - \(nsError.code): \(nsError.localizedDescription)"
        } else {
            errorDescription = String(describing: error)
        }

        TelemetryManager.send("logError", with: ["errorDescription": errorDescription])
    }

    public static func crash(_ message: String) -> Never {
        TelemetryManager.send("crash", with: ["message": message])
        return fatalError(message)
    }

    public static func notImplemented(file: String = #fileID, function: String = #function) -> Never {
        TelemetryManager.send("notImplemented", with: ["file": file, "function": function])
        return fatalError("Unimplemented function")
    }
}

@objc(ErrorHandling)
class ErrorHandlingObjC: NSObject {}

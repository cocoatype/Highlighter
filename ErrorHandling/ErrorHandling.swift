//  Created by Geoff Pado on 5/16/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation
@_implementationOnly import Sentry

public enum ErrorHandling {
    public static func setup() {
        SentrySDK.start { options in
            options.dsn = "https://5cd823be954943b8b6ff4786082ad91d@crashes.cocoatype.com/2"
            options.debug = true
            options.integrations = options.integrations?.filter { integration in
                let bannedIntegrations = ["SentryAutoBreadcrumbTrackingIntegration", "SentryAutoSessionTrackingIntegration"]
                return bannedIntegrations.contains(integration) == false
            }
            dump(options.integrations)
        }
    }

    public static func log(_ error: Error) {
        SentrySDK.capture(error: error)
    }

    public static func crash(_ message: String) -> Never {
        SentrySDK.configureScope { scope in
            scope.setExtra(value: message, key: "Crash Message")
        }
        return fatalError(message)
    }

    public static func notImplemented(file: StaticString = #fileID, function: StaticString = #function) -> Never {
        SentrySDK.configureScope { scope in
            scope.setExtra(value: "\(file): \(function)", key: "Not Implemented")
        }
        return fatalError("Unimplemented function")
    }
}

@objc(ErrorHandling)
class ErrorHandlingObjC: NSObject {}

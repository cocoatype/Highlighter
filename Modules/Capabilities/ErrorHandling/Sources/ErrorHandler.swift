//  Created by Geoff Pado on 5/16/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

import Logging

public protocol ErrorHandler: Sendable {
    func log(_ error: Error, module: StaticString, type: StaticString)
    func crash(_ message: String) -> Never
    func notImplemented(in file: String, function: String) -> Never
}

public extension ErrorHandler {
    func notImplemented(file: String = #fileID, function: String = #function) -> Never {
        self.notImplemented(in: file, function: function)
    }
}

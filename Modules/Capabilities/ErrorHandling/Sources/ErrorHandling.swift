//  Created by Geoff Pado on 5/16/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation
import Logging

public protocol ErrorHandling {
    init(logger: Logger)
    func log(_ error: Error)
    func crash(_ message: String) -> Never
    func notImplemented(file: String, function: String) -> Never
}

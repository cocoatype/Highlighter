//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import FactoryKit

import Defaults
import Logging

@MainActor
enum ExportRecorder {
    static func recordExport(style: ExportingEventFactory.OutputStyle) {
        let defaults = Container.shared.defaults()
        defaults.set(defaults.value(for: Keys.numberOfSaves) + 1, for: Keys.numberOfSaves)
        Container.shared.logger().log(ExportingEventFactory().event(style: style))
    }
}

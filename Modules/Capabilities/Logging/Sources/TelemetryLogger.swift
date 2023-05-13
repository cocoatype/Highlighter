//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import TelemetryClient

public struct TelemetryLogger: Logger {
    public static func initializeTelemetry() {
        guard TelemetryManager.isInitialized == false else { return }
        let configuration = TelemetryManagerConfiguration(appID: "2B12B0C1-2C32-414A-BAB4-B20E866EC277")
        TelemetryManager.initialize(with: configuration)
    }

    private let manager: TelemetrySending
    init(manager: TelemetrySending) {
        self.manager = manager
    }

    public init() {
        Self.initializeTelemetry()
        self.init(manager: TelemetryManager.shared)
    }

    public func log(_ event: Event) {
        manager.send(event.value, for: nil, floatValue: nil, with: event.info)
    }
}

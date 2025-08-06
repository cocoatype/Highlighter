//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import OSLog
import TelemetryClient

struct TelemetryLogger: Logger {
    static func initializeTelemetry() {
        guard TelemetryManager.isInitialized == false else { return }
        let configuration = TelemetryManagerConfiguration(appID: "2B12B0C1-2C32-414A-BAB4-B20E866EC277")
        TelemetryDeck.initialize(config: configuration)
    }

    typealias SignalFunction = @Sendable (String, [String: String], Double?, String?) -> Void
    private let signalFunction: SignalFunction
    init(signalFunction: @escaping SignalFunction) {
        self.signalFunction = signalFunction
    }

    init() {
        Self.initializeTelemetry()
        self.init(signalFunction: TelemetryDeck.signal(_:parameters:floatValue:customUserID:))
    }

    func log(_ event: Event) {
        os_log(.info, "TelemetryLogger logged: %@ %@", event.value, event.info)
        signalFunction(event.value, event.info, nil, nil)
    }
}

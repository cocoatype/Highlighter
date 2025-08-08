//  Created by Geoff Pado on 12/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

import FactoryKit
import FactoryTesting

import Defaults
import DefaultsDoubles
import LoggingDoubles

@testable import Exporting
@testable import Logging

@MainActor @Suite(.container)
struct CopyExporterTests {
    @available(iOS 18.0, *)
    @Test("When export succeeds, an event is logged")
    func exportSucceeds() async throws {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider()
        }
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        let exporter = CopyExporter(
            preparedURL: URL(fileURLWithPath: "/"),
            library: StubPhotoLibrary()
        )

        try await exporter.export()

        let loggedEvent = try #require(logger.loggedEvents.first)
        #expect(loggedEvent.name == "Exporting.successfulExport")
        #expect(loggedEvent.info["style"] == "copy")
        #expect(loggedEvent.info["exportCount"] == "1")
    }
}

//  Created by Geoff Pado on 12/5/24.
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

struct InPlaceExporterTests {
    @Test("When export succeeds, an event is logged")
    func exportSucceeds() async throws {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider()
        }
        let logger = SpyLogger()
        let exporter = InPlaceExporter(
            asset: StubExportableAsset(),
            outputFactory: StubOutputFactory(),
            logger: logger,
            library: StubPhotoLibrary()
        )

        try await exporter.export()

        let loggedEvent = try #require(logger.loggedEvents.first)
        #expect(loggedEvent.name == "Exporting.successfulExport")
        #expect(loggedEvent.info["style"] == "inPlace")
        #expect(loggedEvent.info["exportCount"] == "1")
    }
}

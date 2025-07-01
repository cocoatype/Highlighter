//  Created by Geoff Pado on 12/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Defaults
import DefaultsDoubles
import LoggingDoubles
import XCTest

@testable import Exporting
@testable import Logging

class CopyExporterTests: XCTestCase {
    @MainActor
    func testWhenExporterSucceedsThenEventLogged() async throws {
        let logger = SpyLogger()
        let exporter = CopyExporter(
            preparedURL: URL(fileURLWithPath: "/"),
            defaults: StubDefaultsProvider(),
            logger: logger,
            library: StubPhotoLibrary()
        )

        try await exporter.export()

        let loggedEvent = try XCTUnwrap(logger.loggedEvents.first)
        XCTAssertEqual(loggedEvent.name, "Exporting.successfulExport")
        XCTAssertEqual(loggedEvent.info["style"], "copy")
        XCTAssertEqual(loggedEvent.info["exportCount"], "1")
    }
}

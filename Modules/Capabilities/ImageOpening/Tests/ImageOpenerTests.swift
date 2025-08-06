//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing
import UIKit

@testable import ImageOpening

struct ImageOpenerTests {
    @Test
    func openImage() throws {
        let boltImage = try #require(UIImage(systemName: "bolt"))
        let boltData = try #require(boltImage.pngData())
        let boltEncoded = boltData.base64EncodedString()
        let boltURL = try #require(URL(string: "data:image/png;base64,\(boltEncoded)"))

        #expect(throws: ImageOpeningError.securityScopeDenied) {
            try ImageOpener().openImage(at: boltURL)
        }
    }
}

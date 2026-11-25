//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import DefaultsDoubles

@testable import Editing

@MainActor @Suite(.container)
struct PhotoEditingTextDetectionControllerTests {
    init() {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(autoRedactions: ["secret": true])
        }
    }

    @Test func autoRedactsRecognizedTextOnFirstDetection() async {
        Container.shared.textDetector.register { StubTextDetector(recognizedStrings: ["secret", "public"]) }
        let photoEditingView = PhotoEditingScrollView()
        let controller = PhotoEditingTextDetectionController(
            photoEditingView: photoEditingView,
            autoRedactor: PhotoEditingAutoRedactor(photoEditingView: photoEditingView)
        )

        await controller.detectTextAndAutoRedact(in: UIImage())

        #expect(photoEditingView.redactions.count == 1)
    }

    @Test func doesNotAutoRedactUnlistedText() async {
        Container.shared.textDetector.register { StubTextDetector(recognizedStrings: ["public"]) }
        let photoEditingView = PhotoEditingScrollView()
        let controller = PhotoEditingTextDetectionController(
            photoEditingView: photoEditingView,
            autoRedactor: PhotoEditingAutoRedactor(photoEditingView: photoEditingView)
        )

        await controller.detectTextAndAutoRedact(in: UIImage())

        #expect(photoEditingView.redactions.isEmpty)
    }
}

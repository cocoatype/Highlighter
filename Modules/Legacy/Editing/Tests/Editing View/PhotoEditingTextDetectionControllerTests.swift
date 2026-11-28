//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

import FactoryKit
import FactoryTesting

import DefaultsDoubles
import Detections

@testable import Editing

@MainActor @Suite(.container)
struct PhotoEditingTextDetectionControllerTests {
    init() {
        Container.shared.defaults.register { @MainActor in
            StubDefaultsProvider(autoRedactions: ["secret": true])
        }
    }

    @Test func autoRedactsRecognizedTextOnFirstDetection() async throws {
        Container.shared.textDetector.register { StubTextDetector(recognizedStrings: ["secret", "public"]) }
        let photoEditingView = PhotoEditingScrollView()
        let controller = PhotoEditingTextDetectionController(
            photoEditingView: photoEditingView,
            autoRedactor: PhotoEditingAutoRedactor(photoEditingView: photoEditingView)
        )

        await controller.detectTextAndAutoRedact(in: try blankImage())

        #expect(photoEditingView.redactions.count == 1)
    }

    @Test func doesNotAutoRedactUnlistedText() async throws {
        Container.shared.textDetector.register { StubTextDetector(recognizedStrings: ["public"]) }
        let photoEditingView = PhotoEditingScrollView()
        let controller = PhotoEditingTextDetectionController(
            photoEditingView: photoEditingView,
            autoRedactor: PhotoEditingAutoRedactor(photoEditingView: photoEditingView)
        )

        await controller.detectTextAndAutoRedact(in: try blankImage())

        #expect(photoEditingView.redactions.isEmpty)
    }

    private func blankImage() throws -> DetectableImage {
        let context = try #require(CGContext(
            data: nil,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        return try DetectableImage(cgImage: #require(context.makeImage()))
    }
}

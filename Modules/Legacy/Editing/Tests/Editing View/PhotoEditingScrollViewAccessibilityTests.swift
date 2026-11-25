//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing
import UIKit
import Vision

import struct Observations.RecognizedText
import struct Observations.RecognizedTextObservation
import protocol Observations.VisionText

@testable import Editing

@MainActor
struct PhotoEditingScrollViewAccessibilityTests {
    @Test func settingRecognizedTextCreatesWordAccessibilityElements() throws {
        let scrollView = PhotoEditingScrollView()

        scrollView.recognizedTextObservations = [try recognizedTextObservation("hello world")]

        #expect(accessibilityLabels(in: scrollView) == ["hello", "world"])
    }

    @Test func settingTextRectanglesAfterRecognizedTextKeepsWordAccessibilityElements() throws {
        let scrollView = PhotoEditingScrollView()

        scrollView.recognizedTextObservations = [try recognizedTextObservation("hello world")]
        scrollView.textObservations = []

        #expect(accessibilityLabels(in: scrollView) == ["hello", "world"])
    }

    private func accessibilityLabels(in scrollView: PhotoEditingScrollView) -> [String?] {
        let elements = scrollView.workspaceView.accessibilityElements ?? []
        return elements.map { ($0 as? WordObservationAccessibilityElement)?.accessibilityLabel }
    }

    private func recognizedTextObservation(_ string: String) throws -> RecognizedTextObservation {
        let recognizedText = RecognizedText(recognizedText: StubVisionText(string), uuid: UUID())
        return try #require(RecognizedTextObservation(recognizedText, imageSize: CGSize(width: 100, height: 100)))
    }
}

private struct StubVisionText: VisionText {
    init(_ string: String) {
        self.string = string
    }

    let string: String

    func boundingBox(for range: Range<String.Index>) throws -> VNRectangleObservation? {
        VNRectangleObservation(boundingBox: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}

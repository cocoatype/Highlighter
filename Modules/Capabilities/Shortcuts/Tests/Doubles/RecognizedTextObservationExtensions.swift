//
//  RecognizedTextObservationExtension.swift
//  Highlighter
//
//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.
//

import Foundation
import Testing

import Observations

extension Observations.RecognizedTextObservation {
    init(_ string: String) throws {
        let visionText = MockVisionText(string)
        let recognizedText = RecognizedText(recognizedText: visionText, uuid: UUID())
        let value = try #require(RecognizedTextObservation(recognizedText, imageSize: .zero))
        self = value
    }
}

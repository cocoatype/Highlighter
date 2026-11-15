//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Detections
import ErrorHandling

/// Detects and recognizes text in the editing image, hands the results to
/// the editing view, and applies auto-redactions once text is recognized.
@MainActor
final class PhotoEditingTextDetectionController {
    init(photoEditingView: PhotoEditingScrollView, autoRedactor: PhotoEditingAutoRedactor) {
        self.photoEditingView = photoEditingView
        self.autoRedactor = autoRedactor
    }

    func detectText(in image: UIImage) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let textObservations = try await textRectangleDetector.detectText(in: image)
                photoEditingView.textObservations = textObservations
            } catch { errorHandler.log(error, module: "Editing", type: "PhotoEditingViewController") }
        }

        Task { [weak self] in
            guard let self else { return }
            do {
                let recognizedTextObservations = try await textRectangleDetector.recognizeText(in: image)
                photoEditingView.recognizedTextObservations = recognizedTextObservations
                autoRedactor.autoRedact()
            } catch { errorHandler.log(error, module: "Editing", type: "PhotoEditingViewController") }
        }
    }

    // MARK: Boilerplate

    @Injected(\.errorHandler) private var errorHandler
    private let textRectangleDetector = TextDetector()
    private let photoEditingView: PhotoEditingScrollView
    private let autoRedactor: PhotoEditingAutoRedactor
}

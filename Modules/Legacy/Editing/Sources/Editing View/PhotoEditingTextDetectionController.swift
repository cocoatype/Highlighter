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
        detectionTask?.cancel()
        detectionTask = Task { [weak self] in
            await self?.detectTextAndAutoRedact(in: image)
        }
    }

    /// Runs text detection and recognition, then applies auto-redactions
    /// once the redactable observations have been calculated from both.
    func detectTextAndAutoRedact(in image: UIImage) async {
        async let detection: Void = detectTextRectangles(in: image)
        async let recognition = recognizeText(in: image)
        let (_, didRecognizeText) = await (detection, recognition)

        guard didRecognizeText, Task.isCancelled == false else { return }
        await photoEditingView.redactableCharacterObservationsUpdated()

        guard Task.isCancelled == false else { return }
        autoRedactor.autoRedact()
    }

    private func detectTextRectangles(in image: UIImage) async {
        do {
            let textObservations = try await textDetector.detectText(in: image)
            guard Task.isCancelled == false else { return }
            photoEditingView.textObservations = textObservations
        } catch { errorHandler.log(error, module: "Editing", type: "PhotoEditingViewController") }
    }

    /// Returns whether text was recognized.
    private func recognizeText(in image: UIImage) async -> Bool {
        do {
            let recognizedTextObservations = try await textDetector.recognizeText(in: image)
            guard Task.isCancelled == false else { return false }
            photoEditingView.recognizedTextObservations = recognizedTextObservations
            return true
        } catch {
            errorHandler.log(error, module: "Editing", type: "PhotoEditingViewController")
            return false
        }
    }

    // MARK: Boilerplate

    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.textDetector) private var textDetector
    private var detectionTask: Task<Void, Never>?
    private let photoEditingView: PhotoEditingScrollView
    private let autoRedactor: PhotoEditingAutoRedactor
}

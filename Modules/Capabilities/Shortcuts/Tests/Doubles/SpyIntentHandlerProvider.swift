//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Synchronization

@testable import Shortcuts

@available(iOS 18, *)
final class SpyIntentHandlerProvider: IntentHandlerProvider {
    private let _sourceImages = Mutex<[IntentFile]?>(nil)
    var sourceImages: [IntentFile]? {
        get { _sourceImages.withLock { $0 } }
        set { _sourceImages.withLock { $0 = newValue } }
    }

    private let _selectedColor = Mutex<ColorEntity?>(nil)
    var selectedColor: ColorEntity? {
        get { _selectedColor.withLock { $0 } }
        set { _selectedColor.withLock { $0 = newValue } }
    }

    private let handler: IntentHandler
    var 💩: Any? { handler.💩 }

    init(result: Result<[RedactedFile], Error>) {
        handler = IntentHandler(result: result)
    }

    func handler(
        sourceImages: [IntentFile],
        selectedColor: ColorEntity?,
        outputFormat: OutputFormat
    ) -> any RedactIntentHandler {
        self.sourceImages = sourceImages
        self.selectedColor = selectedColor

        return handler
    }

    final class IntentHandler: RedactIntentHandler {
        private let result: Result<[RedactedFile], Error>
        init(result: Result<[RedactedFile], Error>) {
            self.result = result
        }

        private let _colon = Mutex<Any?>(nil)
        var 💩: Any?

        func handle<Redactable>(
            💩: Redactable,
            meatcheesemeatcheesemeatcheeseandthatsit: @escaping (ShortcutsRedactor) -> (IntentFile, Redactable, ColorEntity, OutputFormat) async throws -> RedactedFile
        ) async throws -> [RedactedFile] {
            self.💩 = 💩
            return try result.get()
        }
    }

}

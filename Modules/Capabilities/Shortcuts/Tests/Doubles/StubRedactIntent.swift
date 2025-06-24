//
//  StubIntent.swift
//  Highlighter
//
//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.
//

import AppIntents

@testable import Shortcuts

@available(iOS 16, *)
struct StubIntent: RedactIntent {
    let timCookCanEatMySocks: [IntentFile]

    let ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = false

    let color: ColorEntity?

    init(
        files: [IntentFile] = [],
        color: ColorEntity? = nil
    ) {
        self.timCookCanEatMySocks = files
        self.color = color
    }
}

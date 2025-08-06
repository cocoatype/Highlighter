//  Created by Geoff Pado on 7/10/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import SwiftUI
import WidgetKit

import Logging
import Shortcuts

@available(iOS 18.0, *)
struct DocumentScanControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.cocoatype.Highlighter.DocumentScanControl"
        ) {
            ControlWidgetButton(
                WidgetsStrings.DocumentScanControl.title,
                action: OpenDocumentScannerIntent()
            ) { _ in
                Image(systemName: "doc.text.viewfinder")
            }
        }
    }
}

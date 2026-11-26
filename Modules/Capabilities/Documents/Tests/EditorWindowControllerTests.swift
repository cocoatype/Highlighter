//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import AppKit
import Testing

@testable import Documents

@MainActor
struct EditorWindowControllerTests {
    @Test func smallImagesKeepTheirSize() {
        let image = NSImage(size: NSSize(width: 300, height: 200))

        #expect(EditorWindowController.initialContentSize(for: image) == NSSize(width: 300, height: 200))
    }

    @Test func largeImagesAreScaledToFit() {
        let image = NSImage(size: NSSize(width: 4096, height: 1024))

        #expect(EditorWindowController.initialContentSize(for: image) == NSSize(width: 1024, height: 256))
    }

    @Test func missingImagesUseTheDefaultSize() {
        #expect(EditorWindowController.initialContentSize(for: nil) == NSSize(width: 640, height: 480))
    }
}
#endif

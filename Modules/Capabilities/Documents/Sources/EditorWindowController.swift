//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import AppKit

/// The window controller for an editor window. Every editor window is made
/// by an `ImageDocument`, which owns it. For now the window only shows the
/// document's image; the editing view replaces it later in #487.
public final class EditorWindowController: NSWindowController {
    public init(image: NSImage?) {
        let imageView = NSImageView()
        imageView.image = image
        imageView.imageScaling = .scaleProportionallyUpOrDown

        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: Self.initialContentSize(for: image)),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: true
        )
        window.contentView = imageView
        window.center()

        super.init(window: window)
        shouldCloseDocument = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static let maximumInitialContentSize = NSSize(width: 1024, height: 768)
    private static let defaultContentSize = NSSize(width: 640, height: 480)

    /// The image's size, scaled down to fit the maximum initial size.
    static func initialContentSize(for image: NSImage?) -> NSSize {
        guard let size = image?.size, size.width > 0, size.height > 0 else {
            return defaultContentSize
        }

        let scale = min(
            1,
            maximumInitialContentSize.width / size.width,
            maximumInitialContentSize.height / size.height
        )
        return NSSize(width: (size.width * scale).rounded(), height: (size.height * scale).rounded())
    }
}
#endif

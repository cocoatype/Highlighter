//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import AppKit

/// The document behind each editor window in the native AppKit app.
///
/// A document is the source image only: it reads a PNG, JPEG, or HEIC file,
/// and saving (#626) will write the flattened, redacted image back to that
/// file, so original pixels never end up in a saved file. Autosave, drafts,
/// and versions are all turned off, so unredacted data is never written
/// anywhere it could be recovered, and closing an edited document asks the
/// user to save.
///
/// The Objective-C name is fixed so that `NSDocumentClass` in the app's
/// `Info.plist` doesn't depend on the module name.
@objc(ImageDocument)
public final class ImageDocument: NSDocument {
    /// The image read from the document's file, or `nil` before reading.
    public private(set) var image: NSImage?

    /// The redactions applied to the image. Changing them marks the
    /// document as edited.
    public var redactions: [DocumentRedaction] {
        get { storedRedactions }
        set {
            guard newValue != storedRedactions else { return }
            storedRedactions = newValue
            updateChangeCount(.changeDone)
        }
    }

    private var storedRedactions: [DocumentRedaction] = []

    public func add(_ redaction: DocumentRedaction) {
        redactions.append(redaction)
    }

    // MARK: Autosaving

    override public static var autosavesInPlace: Bool { false }
    override public static var autosavesDrafts: Bool { false }
    override public static var preservesVersions: Bool { false }

    // MARK: Window controllers

    override public func makeWindowControllers() {
        addWindowController(EditorWindowController(image: image))
    }

    // MARK: Reading and writing

    // Reading always happens on the main thread, which `read(from:ofType:)`
    // relies on.
    override public static func canConcurrentlyReadDocuments(ofType typeName: String) -> Bool {
        false
    }

    override public func read(from data: Data, ofType typeName: String) throws {
        guard let image = NSImage(data: data), image.isValid else {
            throw CocoaError(.fileReadCorruptFile)
        }

        MainActor.assumeIsolated {
            self.image = image
            // Assign the stored value directly, so reading doesn't mark the
            // document as edited.
            storedRedactions = []
        }
    }

    override public func data(ofType typeName: String) throws -> Data {
        // Writing the flattened image is added with saving in #626. Until
        // then, fail with an error that NSDocument presents, rather than
        // silently not writing the file (#495).
        throw CocoaError(.featureUnsupported)
    }
}
#endif

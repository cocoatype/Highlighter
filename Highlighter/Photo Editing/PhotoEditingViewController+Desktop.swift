//  Created by Geoff Pado on 8/10/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit
import UniformTypeIdentifiers

#if targetEnvironment(macCatalyst)
extension PhotoEditingViewController {
    private var imageType: UTType? {
        guard let imageTypeString = image?.cgImage?.utType
        else { return nil }

        return UTType(imageTypeString as String)
    }

    @objc func save(_ sender: Any) {
        guard let exportURL = fileURLProvider?.representedFileURL else { return saveAs(sender) }
        guard let imageType = imageType else { return present(.missingImageType) }

        exportImage { [weak self] image in
            let data: Data?

            switch imageType {
            case .jpeg:
                data = image?.jpegData(compressionQuality: 0.9)
            case .png: fallthrough
            default:
                data = image?.pngData()
            }

            guard let exportData = data else {
                DispatchQueue.main.async { [weak self] in
                    self?.present(.noImageData)
                }
                return
            }
            do {
                try exportData.write(to: exportURL)
                self?.clearHasMadeEdits()

                Defaults.numberOfSaves += 1
                DispatchQueue.main.async { [weak self] in
                    AppRatingsPrompter.displayRatingsPrompt(in: self?.view.window?.windowScene)
                }
            } catch {}
        }
    }

    @objc func saveAs(_ sender: Any) {
        guard let imageType = imageType else { return present(.missingImageType) }

        let representedURLName = fileURLProvider?.representedFileURL?.lastPathComponent ?? "\(Self.defaultImageName).\(imageType.preferredFilenameExtension ?? "png")"
        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(representedURLName)

        exportImage { [weak self] image in
            let data: Data?

            switch imageType {
            case .jpeg:
                data = image?.jpegData(compressionQuality: 0.9)
            case .png: fallthrough
            default:
                data = image?.pngData()
            }

            guard let exportData = data else {
                DispatchQueue.main.async { [weak self] in
                    self?.present(.noImageData)
                }
                return
            }
            do {
                try exportData.write(to: temporaryURL)
                self?.clearHasMadeEdits()

                Defaults.numberOfSaves += 1
                DispatchQueue.main.async { [weak self] in
                    let saveViewController = DesktopSaveViewController(url: temporaryURL) { [weak self] urls in
                        AppRatingsPrompter.displayRatingsPrompt(in: self?.view.window?.windowScene)
                        if let exportURL = urls.first {
                            self?.fileURLProvider?.updateRepresentedFileURL(to: exportURL)
                        }
                    }
                    self?.present(saveViewController, animated: true, completion: nil)
                }
            } catch {}
        }
    }

    private func present(_ error: DesktopSaveError) {
        present(DesktopSaveAlertController(error: error), animated: true, completion: nil)
    }

    var canSave: Bool {
        guard let imageType = imageType else { return false }
        guard hasMadeEdits == true else { return false }
        return [UTType.png, .jpeg].contains(imageType)
    }

    private static let defaultImageName = NSLocalizedString("PhotoEditingViewController.defaultImageName", comment: "Default name when saving the image on macOS")
}

class DesktopSaveViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    private var onSave: (([URL]) -> Void)? = nil
    convenience init(url: URL, onSave: @escaping (([URL]) -> Void)) {
        self.init(forExporting: [url], asCopy: true)
        self.onSave = onSave
        delegate = self
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let onSave = self.onSave else { return }
        DispatchQueue.main.async {
            onSave(urls)
        }
    }
}

enum DesktopSaveError: Error {
    case missingRepresentedURL
    case missingImageType
    case noImageData

    var alertTitle: String {
        switch self {
        case .missingRepresentedURL: return NSLocalizedString("DesktopSaveError.missingRepresentedURL.alertTitle", comment: "Title for the missing represented URL alert")
        case .missingImageType: return NSLocalizedString("DesktopSaveError.missingImageType.alertTitle", comment: "Title for the missing image type alert")
        case .noImageData: return NSLocalizedString("DesktopSaveError.noImageData.alertTitle", comment: "Title for the no export data alert")
        }
    }

    var alertMessage: String {
        return NSLocalizedString("DesktopSaveError.alertMessage", comment: "Message for the missing represented URL alert")
    }
}

class DesktopSaveAlertController: UIAlertController {
    convenience init(error: DesktopSaveError) {
        self.init(title: error.alertTitle, message: error.alertMessage, preferredStyle: .alert)
        addAction(UIAlertAction(title: Self.dismissButtonTitle, style: .default, handler: nil))
    }

    private static let dismissButtonTitle = NSLocalizedString("DesktopSaveAlertController.dismissButtonTitle", comment: "Dismiss button for the save error alert")
}
#endif

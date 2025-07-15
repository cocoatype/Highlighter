//  Created by Geoff Pado on 8/10/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit
import UniformTypeIdentifiers

import FactoryKit

import AppRatings
import Defaults
import ErrorHandling
import Exporting

#if targetEnvironment(macCatalyst)
extension PhotoEditingViewController {
    private var imageType: UTType? {
        guard let imageTypeString = image?.cgImage?.utType
        else { return nil }

        return UTType(imageTypeString as String)
    }

    @objc public func save(_ sender: Any) {
        guard let exportURL = fileURLProvider?.representedFileURL else { return saveAs(sender) }

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                try await FileManager.default.copyItem(at: preparedURL, to: exportURL)
                clearHasMadeEdits()

                defaults.set(defaults.value(for: Keys.numberOfSaves) + 1, for: Keys.numberOfSaves)
                await AppRatingsPrompter().displayRatingsPrompt(in: view.window?.windowScene)
            } catch {
                Container.shared.errorHandler().log(error)
            }
        }
    }

    @objc @MainActor public func saveAs(_ sender: Any) {
        Task { @MainActor [weak self] in
            do {
                guard let self else { return }
                clearHasMadeEdits()

                defaults.set(defaults.value(for: Keys.numberOfSaves) + 1, for: Keys.numberOfSaves)
                let temporaryURL = try await preparedURL
                let saveViewController = DesktopSaveViewController(url: temporaryURL) { [weak self] urls in
                    Task {
                        await AppRatingsPrompter().displayRatingsPrompt(in: self?.view.window?.windowScene)
                    }
                    if let exportURL = urls.first {
                        self?.fileURLProvider?.updateRepresentedFileURL(to: exportURL)
                    }
                }
                present(saveViewController, animated: true)
            } catch {
                Container.shared.errorHandler().log(error)
            }
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
}
#endif

//  Created by Geoff Pado on 10/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import MobileCoreServices
import Photos
import PhotosUI

import FactoryKit

import Editing
import ErrorHandling
import Exporting
import Redactions

class PhotoExtensionViewController: UIViewController, PHContentEditingController {
    init() {
        super.init(nibName: nil, bundle: nil)
        embed(PhotoLoadingViewController())
    }

    // MARK: PHContentEditingController

    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool { return false }

    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        input = contentEditingInput
        guard let displayImage = contentEditingInput.displaySizeImage else { return }
        transition(to: PhotoNavigationController(image: displayImage))
    }

    func finishContentEditing(completionHandler: @escaping (PHContentEditingOutput?) -> Void) {
        Task { [weak self] in
            do {
                guard let preparedURL = try await self?.editingViewController?.preparedURL,
                      let redactions = self?.editingViewController?.redactions,
                      let input = self?.input
                else { return completionHandler(nil) }

                let factory = Exporting.outputFactory(preparedURL: preparedURL, redactions: redactions)
                let output = try factory.output(from: input)
                completionHandler(output)
            } catch {
                Container.shared.errorHandler().log(error)
                completionHandler(nil)
            }
        }
    }

    func cancelContentEditing() {}

    var shouldShowCancelConfirmation: Bool { return editingViewController?.hasMadeEdits ?? false }

    // MARK: Boilerplate

    private static let formatIdentifier = "com.cocoatype.Highlighter.redactionsFormat"

    private var editingViewController: PhotoEditingViewController? { return children.compactMap { $0 as? PhotoNavigationController }.first?.viewControllers.first as? PhotoEditingViewController }

    private var input: PHContentEditingInput?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

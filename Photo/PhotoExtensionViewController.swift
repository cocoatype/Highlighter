//  Created by Geoff Pado on 10/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import MobileCoreServices
import Photos
import PhotosUI

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
        editingViewController?.exportImage { [weak self] image in
            guard let input = self?.input,
              let outputImage = image,
              let outputData = self?.imageOutputData(from: outputImage, typeIdentifier: input.uniformTypeIdentifier)
            else { return completionHandler(nil) }

            do {
                let output = PHContentEditingOutput(contentEditingInput: input)

                let redactions = self?.editingViewController?.redactions ?? []
                let serializedRedactions = redactions.map(RedactionSerializer.dataRepresentation(of:))
                let adjustmentData = try JSONEncoder().encode(serializedRedactions)

                output.adjustmentData = PHAdjustmentData(formatIdentifier: Self.formatIdentifier, formatVersion: "1", data: adjustmentData)
                try outputData.write(to: output.renderedContentURL)
                completionHandler(output)
            } catch {
                completionHandler(nil)
                return
            }
        }
    }

    func cancelContentEditing() {}

    var shouldShowCancelConfirmation: Bool { return editingViewController?.hasMadeEdits ?? false }

    // MARK: Image Output

    private func imageOutputData(from image: UIImage, typeIdentifier: String?) -> Data? {
        if let typeIdentifier = typeIdentifier, typeIdentifier == (kUTTypePNG as String) {
            return image.pngData()
        } else {
            return image.jpegData(compressionQuality: 0.9)
        }
    }

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

class PhotoNavigationController: NavigationController {
    init(image: UIImage) {
        super.init(rootViewController: PhotoEditingViewController(image: image))
        isToolbarHidden = false
        setNavigationBarHidden(true, animated: false)
    }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoLoadingViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = PhotoLoadingView()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoLoadingView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func didMoveToSuperview() {
        spinner.startAnimating()
    }

    // MARK: Boilerplate

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .primaryExtraLight
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

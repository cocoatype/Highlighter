//  Created by Geoff Pado on 6/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

class PhotoEditingViewController: BasePhotoEditingViewController {
    override init(asset: PHAsset? = nil, image: UIImage? = nil, redactions: [Redaction]? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        super.init(asset: asset, image: image, redactions: redactions, completionHandler: completionHandler)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissPhotoEditingViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PhotoEditingViewController.sharePhoto))

        userActivity = EditingUserActivity()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override var canBecomeFirstResponder: Bool { return true }

    // MARK: Edit Protection

    private(set) var hasMadeEdits = false
    @objc override func markHasMadeEdits() {
        hasMadeEdits = true
    }

    // MARK: Sharing

    @objc func sharePhoto(_ sender: Any) {
        exportImage { [weak self] image in
            guard let exportedImage = image else { return }

            let activityController = UIActivityViewController(activityItems: [exportedImage], applicationActivities: nil)
            activityController.completionWithItemsHandler = { [weak self] _, completed, _, _ in
                self?.hasMadeEdits = false
                Defaults.numberOfSaves = Defaults.numberOfSaves + 1
                AppRatingsPrompter.displayRatingsPrompt()
            }

            DispatchQueue.main.async { [weak self] in
                activityController.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                self?.present(activityController, animated: true)
            }
        }
    }

    private var imageType: UTType? {
        guard let imageTypeString = image?.cgImage?.utType
        else { return nil }

        return UTType(imageTypeString as String)
    }

    @objc func save(_ sender: Any) {
        guard let exportURL = view.window?.windowScene?.titlebar?.representedURL, let imageType = imageType else { return }

        exportImage { [weak self] image in
            let data: Data?

            switch imageType {
            case .jpeg:
                data = image?.jpegData(compressionQuality: 0.9)
            case .png: fallthrough
            default:
                data = image?.pngData()
            }

            guard let exportData = data else { return }
            do {
                try exportData.write(to: exportURL)
                self?.hasMadeEdits = false
            } catch {}
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(save(_:)) {
            guard let imageType = imageType else { return false }
            guard hasMadeEdits == true else { return false }
            return [UTType.png, .jpeg].contains(imageType)
        }

        return super.canPerformAction(action, withSender: sender)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

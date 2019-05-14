//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoEditingViewController: UIViewController, UIScrollViewDelegate {
    init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissPhotoEditingViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PhotoEditingViewController.sharePhoto))
    }

    override func loadView() {
        view = PhotoEditingScrollView()
        photoScrollView?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { [weak self] image, info in
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
            guard let image = image, isDegraded == false else { return }

            self?.textRectangleDetector.detectTextRectangles(in: image) { (textObservations) in
                DispatchQueue.main.async { [weak self] in
                    self?.photoScrollView?.textObservations = textObservations
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.photoScrollView?.image = image
            }
        }
    }

    // MARK: Edit Protection

    private(set) var hasMadeEdits = false
    @objc func markHasMadeEdits() {
        hasMadeEdits = true
    }

    // MARK: Sharing

    @objc func sharePhoto() {
        guard let editingView = photoScrollView?.photoEditingView, let image = editingView.image else { return }
        let photoExporter = PhotoExporter(image: image, redactions: editingView.redactions)
        guard let exportedImage = photoExporter.exportedImage else { return }

        let activityController = UIActivityViewController(activityItems: [exportedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { [weak self] _, completed, _, _ in
            self?.hasMadeEdits = false
        }

        present(activityController, animated: true)
    }

    // MARK: UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoScrollView?.photoEditingView
    }

    // MARK: Boilerplate

    private let asset: PHAsset
    private let imageManager = PHImageManager()
    private let textRectangleDetector = TextRectangleDetector()
    private var photoScrollView: PhotoEditingScrollView? { return (view as? PhotoEditingScrollView) }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

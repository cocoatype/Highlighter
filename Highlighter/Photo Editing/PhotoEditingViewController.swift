//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoEditingViewController: UIViewController {
    init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissPhotoEditingViewController))
    }

    override func loadView() {
        view = PhotoEditingView()
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
                    self?.photoEditingView?.textObservations = textObservations
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.photoEditingView?.image = image
            }
        }
    }

    // MARK: Boilerplate

    private let asset: PHAsset
    private let imageManager = PHImageManager()
    private var photoEditingView: PhotoEditingView? { return view as? PhotoEditingView }
    private let textRectangleDetector = TextRectangleDetector()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

class AssetPhotoLibraryViewCell: UICollectionViewCell {
    static let identifier = "AssetPhotoLibraryViewCell.identifier"

    var asset: PHAsset? {
        didSet {
            guard let asset = asset else {
                assetRequestID = nil
                imageView.image = nil
                return
            }

            let targetSize = bounds.size * UIScreen.main.scale

            assetRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, info in
                guard let image = image,
                  let requestID = (info?[PHImageResultRequestIDKey] as? NSNumber)?.int32Value,
                  self?.assetRequestID == requestID
                else { return }

                self?.imageView.image = image
            }

            let dateString: String
            if let date = asset.creationDate {
                dateString = Self.dateFormatter.string(from: date)
            } else { dateString = "" }
            accessibilityLabel = String(format: Self.accessibilityLabelFormat, dateString)
            accessibilityTraits = .button
        }
    }

    override init(frame: CGRect) {
        imageView = AssetPhotoLibraryViewCellImageView()

        super.init(frame: .zero)

        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        isAccessibilityElement = true
        backgroundColor = .primaryDark
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        asset = nil
    }

    // MARK: Boilerplate

    private static let accessibilityLabelFormat = NSLocalizedString("AssetPhotoLibraryViewCell.accessibilityLabelFormat%@", comment: "Accessiblity label format for asset cells")
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()

    private let imageManager = PHImageManager.default()
    private var imageView: UIImageView

    private var assetRequestID: PHImageRequestID? {
        didSet {
            guard let oldValue = oldValue else { return }
            imageManager.cancelImageRequest(oldValue)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

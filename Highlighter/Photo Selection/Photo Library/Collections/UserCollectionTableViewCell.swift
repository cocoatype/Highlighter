//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

class UserCollectionTableViewCell: UITableViewCell, CollectionTableViewCell {
    static let identifier = "UserCollectionTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .primary

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .primaryLight
        self.selectedBackgroundView = selectedBackgroundView

        contentView.addSubview(label)
        contentView.addSubview(photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoImageView.widthAnchor.constraint(equalToConstant: 36),
            photoImageView.heightAnchor.constraint(equalToConstant: 36),
            label.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    var collection: Collection? {
        didSet {
            label.text = collection?.title
            asset = (collection as? AssetCollection)?.keyAssets.firstObject
        }
    }

    // MARK: Image Loading

    private let imageManager = PHImageManager.default()

    private var asset: PHAsset? {
        didSet {
            guard let asset = asset else {
                assetRequestID = nil
                photoImageView.image = nil
                return
            }

            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            let targetSize = CGSize(width: 36, height: 36) * UIScreen.main.scale

            let assetRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { [weak self] image, info in
                guard let image = image,
                  let requestID = (info?[PHImageResultRequestIDKey] as? NSNumber)?.int32Value,
                  self?.assetRequestID == requestID
                else { return }

                self?.photoImageView.image = image
                self?.setNeedsLayout()
            }
            self.assetRequestID = assetRequestID
        }
    }

    private var assetRequestID: PHImageRequestID? {
        didSet {
            guard let oldValue = oldValue else { return }
            imageManager.cancelImageRequest(oldValue)
        }
    }

    // MARK: Number Formatting

    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        return numberFormatter
    }()

    // MARK: Boilerplate

    private let label = CollectionTableViewCellLabel()
    private let photoImageView = UserCollectionTableViewCellImageView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

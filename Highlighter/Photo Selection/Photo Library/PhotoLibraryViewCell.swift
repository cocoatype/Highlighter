//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoLibraryViewCell: UICollectionViewCell {
    static let identifier = "PhotoLibraryViewCell.identifier"

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
        }
    }

    override init(frame: CGRect) {
        imageView = PhotoLibraryViewCellImageView()

        super.init(frame: .zero)

        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        backgroundColor = .primary
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        asset = nil
    }

    // MARK: Boilerplate

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

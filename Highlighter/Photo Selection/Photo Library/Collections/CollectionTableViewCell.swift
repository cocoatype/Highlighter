//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

protocol CollectionTableViewCell {
    static var identifier: String { get }
    var collection: Collection? { get set }
}

class SystemCollectionTableViewCell: UITableViewCell, CollectionTableViewCell {
    static let identifier = "SystemCollectionTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }

    var collection: Collection? {
        didSet {
            textLabel?.text = collection?.title
            imageView?.image = collection?.icon
            detailTextLabel?.text = Self.numberFormatter.string(from: NSNumber(value: collection?.assets.count ?? 0))
        }
    }

    // MARK: Number Formatting

    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        return numberFormatter
    }()

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

class UserCollectionTableViewCell: UITableViewCell, CollectionTableViewCell {
    static let identifier = "UserCollectionTableViewCell.identifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    var collection: Collection? {
        didSet {
            textLabel?.text = collection?.title
            asset = collection?.keyAssets.firstObject
            detailTextLabel?.text = Self.numberFormatter.string(from: NSNumber(value: collection?.assets.count ?? 0))
        }
    }

    // MARK: Image Loading

    private let imageManager = PHImageManager.default()

    private var asset: PHAsset? {
        didSet {
            guard let asset = asset else {
                assetRequestID = nil
                imageView?.image = nil
                return
            }

            let targetSize = CGSize(width: 70, height: 70) * UIScreen.main.scale

            assetRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, info in
                guard let image = image,
                  let requestID = (info?[PHImageResultRequestIDKey] as? NSNumber)?.int32Value,
                  self?.assetRequestID == requestID
                else { return }

                self?.imageView?.image = image
                self?.setNeedsLayout()
            }
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

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

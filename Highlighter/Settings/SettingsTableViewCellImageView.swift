//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Kingfisher
import UIKit

class SettingsTableViewCellImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    var iconURL: URL? {
        didSet {
            guard let iconURL = iconURL else { kf.cancelDownloadTask(); return }
            kf.setImage(
                with: iconURL,
                options: [
                    .processor(SettingsTableViewCellImageView.imageProcessor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ])
        }
    }

    // MARK: Image Processing

    private static var imageProcessor: ImageProcessor {
        return DownsamplingImageProcessor(size: CGSize(width: 32.0, height: 32.0)) >> RoundCornerImageProcessor(cornerRadius: 5.6)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

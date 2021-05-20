//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewCellImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        accessibilityIgnoresInvertColors = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.6).cgPath
        layer.mask = maskLayer
    }

    var iconURL: URL? {
        didSet {
            let downloader = SettingsTableViewCellImageView.downloader
            guard let iconURL = iconURL else { downloader.cancelDownloadTask(for: self); return }
            downloader.downloadImage(at: iconURL, to: self)
        }
    }

    // MARK: Boilerplate

    private static let downloader = ImageDownloader()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

//  Created by Geoff Pado on 4/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoEditingView: UIView {
    init() {
        imageView = PhotoEditingImageView()

        super.init(frame: .zero)
        backgroundColor = .primary

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }

    var image: UIImage? {
        get { return imageView.image }
        set(newImage) {
            imageView.image = newImage
        }
    }

    // MARK: Boilerplate

    private var imageView: PhotoEditingImageView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

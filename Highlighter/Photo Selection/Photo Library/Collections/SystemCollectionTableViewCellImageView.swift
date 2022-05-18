//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class SystemCollectionTableViewCellImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        contentMode = .center
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .body, scale: .large)
    }

    override var intrinsicContentSize: CGSize { return CGSize(width: 36, height: 36) }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryViewCell: UICollectionViewCell {
    static let identifier = "PhotoLibraryViewCell.identifier"

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .red
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

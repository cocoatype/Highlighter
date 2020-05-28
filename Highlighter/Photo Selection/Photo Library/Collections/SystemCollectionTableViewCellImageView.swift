//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class SystemCollectionTableViewCellImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        contentMode = .center
        preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .body, scale: .large)
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

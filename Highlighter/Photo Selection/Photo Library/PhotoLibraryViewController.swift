//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

@available(iOS 14.0, *)
class PhotoLibraryViewController: UIHostingController<PhotoLibraryView> {
    init(collection: Collection) {
        let dataSource = PhotoLibraryDataSource(collection)
        super.init(rootView: PhotoLibraryView(dataSource: dataSource))

        rootView.action = { [weak self] asset in
            self?.photoEditorPresenter?.presentPhotoEditingViewController(for: asset.photoAsset, redactions: nil, animated: true)
        }

        navigationItem.title = Self.navigationItemTitle
        navigationItem.rightBarButtonItem = SettingsBarButtonItem.standard
    }
    
    // MARK: Boilerplate

    private static let navigationItemTitle = NSLocalizedString("PhotoSelectionViewController.navigationItemTitle", comment: "Navigation title for the photo selector")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

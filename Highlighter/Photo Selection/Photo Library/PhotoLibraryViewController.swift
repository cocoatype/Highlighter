//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        let libraryView = PhotoLibraryView()
        libraryView.dataSource = dataSource
        libraryView.delegate = self
        view = libraryView
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = dataSource.photo(at: indexPath)
        photoEditorPresenter?.presentPhotoEditingViewController(for: asset)
    }

    // MARK: Boilerplate

    private let dataSource = PhotoLibraryDataSource()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

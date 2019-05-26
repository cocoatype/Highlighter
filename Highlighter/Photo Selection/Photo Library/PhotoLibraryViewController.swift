//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UIDropInteractionDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        let libraryView = PhotoLibraryView()
        libraryView.dataSource = dataSource
        libraryView.delegate = self

        let dropInteraction = UIDropInteraction(delegate: self)
        libraryView.addInteraction(dropInteraction)

        view = libraryView
    }

    // MARK: UIDropInteractionDelegate

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("can handle drop?")
        guard session.items.count == 1 else { return false }
        guard session.canLoadObjects(ofClass: UIImage.self) else { return false }

        print("can handle drop!")

        return true
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { [weak self] dropItems in
            guard let image = (dropItems.first as? UIImage) else { return }
            self?.photoEditorPresenter?.presentPhotoEditingViewController(for: image)
        }
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

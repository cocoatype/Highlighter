//  Created by Geoff Pado on 10/14/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import Photos
import PhotosUI

class PhotoExtensionViewController: UIViewController, PHContentEditingController {
    init() {
        super.init(nibName: nil, bundle: nil)
        embed(PhotoLoadingViewController())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dump(view.safeAreaInsets)
        dump(view.layoutMarginsGuide)
    }

    // MARK: PHContentEditingController

    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool { return false }

    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        guard let displayImage = contentEditingInput.displaySizeImage else { return }
        transition(to: PhotoNavigationController(image: displayImage))
    }

    func finishContentEditing(completionHandler: @escaping (PHContentEditingOutput?) -> Void) {}

    func cancelContentEditing() {}

    var shouldShowCancelConfirmation: Bool { return true }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoNavigationController: NavigationController {
    init(image: UIImage) {
        super.init(rootViewController: PhotoEditingViewController(image: image))
        isToolbarHidden = false
        setNavigationBarHidden(true, animated: false)
    }

    // MARK: Boilerplate

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoLoadingViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = PhotoLoadingView()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class PhotoLoadingView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func didMoveToSuperview() {
        spinner.startAnimating()
    }

    // MARK: Boilerplate

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .primaryExtraLight
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

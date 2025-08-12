//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class AdditionViewController: UIViewController {
    private let completionHandler: (String?) -> Void
    init(completionHandler: @escaping (String?) -> Void) {
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .formSheet
        let additionViewSize = additionView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        preferredContentSize = CGSize(width: 320, height: additionViewSize.height)
    }

    override func loadView() {
        view = additionView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        additionView.startTextEntry()
    }

    @objc func saveWord(_ sender: AnyObject) {
        completionHandler(additionView.text)
        dismiss(animated: true)
    }

    @objc func cancel(_ sender: AnyObject) {
        dismiss(animated: true)
    }

    // MARK: Boilerplate

    private let additionView = AdditionView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

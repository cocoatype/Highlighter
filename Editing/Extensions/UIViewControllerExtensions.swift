//  Created by Geoff Pado on 4/29/18.
//  Copyright (c) 2018 Cocoatype, LLC. All rights reserved.

import UIKit

extension UIViewController {
    public func embed(_ newChild: UIViewController) {
        if let existingChild = children.first {
            existingChild.willMove(toParent: nil)
            existingChild.view.removeFromSuperview()
            existingChild.removeFromParent()
        }

        guard let newChildView = newChild.view else { return }
        newChildView.translatesAutoresizingMaskIntoConstraints = false

        addChild(newChild)
        view.addSubview(newChildView)
        newChild.didMove(toParent: self)

        NSLayoutConstraint.activate([
            newChildView.widthAnchor.constraint(equalTo: view.widthAnchor),
            newChildView.heightAnchor.constraint(equalTo: view.heightAnchor),
            newChildView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newChildView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    public func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let duration = 0.3

        let current = children.last
        guard let childView = child.view else { return }

        addChild(child)

        let newView = childView
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds

        if let existing = current {
            existing.willMove(toParent: nil)

            transition(from: existing, to: child, duration: duration, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                existing.removeFromParent()
                child.didMove(toParent: self)
                completion?(done)
            })
        } else {
            view.addSubview(newView)

            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                child.didMove(toParent: self)
                completion?(done)
            })
        }
    }
}

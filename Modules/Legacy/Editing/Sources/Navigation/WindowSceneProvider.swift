//  Created by Geoff Pado on 5/3/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

import UIKit

@MainActor
@objc public protocol WindowSceneProvider {
    var windowScene: UIWindowScene? { get }
}

extension UIViewController: WindowSceneProvider {
    public var windowScene: UIWindowScene? { view.window?.windowScene }
}

extension UIApplication: WindowSceneProvider {
    public var windowScene: UIWindowScene? {
        connectedScenes.lazy
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}

//  Created by Geoff Pado on 7/8/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

extension UINavigationItem {
    var allBarButtonItems: [UIBarButtonItem] {
        if #available(iOS 16, *) {
            return (leadingItemGroups + centerItemGroups + trailingItemGroups).flatMap(\.barButtonItems)
        } else {
            return (leftBarButtonItems ?? []) + (rightBarButtonItems ?? [])
        }
    }
}

extension UIViewController {
    func findBarButtonItem(_ predicate: (UIBarButtonItem) -> Bool) -> UIBarButtonItem? {
        let allBarButtonItems = navigationItem.allBarButtonItems + (toolbarItems ?? [])
        return allBarButtonItems.first(where: predicate)
    }
}

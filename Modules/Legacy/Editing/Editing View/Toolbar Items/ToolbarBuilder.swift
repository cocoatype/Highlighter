//  Created by Geoff Pado on 12/6/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

protocol ToolbarSection {
    var barButtonItems: [UIBarButtonItem] { get }
}

extension UIBarButtonItem: ToolbarSection {
    var barButtonItems: [UIBarButtonItem] { [self] }
}

extension Array: ToolbarSection where Element == UIBarButtonItem {
    var barButtonItems: [UIBarButtonItem] { self }
}

@resultBuilder
struct ToolbarBuilder {
    static func buildBlock(_ components: ToolbarSection...) -> [UIBarButtonItem] {
        components.flatMap(\.barButtonItems)
    }

    static func buildOptional(_ component: [ToolbarSection]?) -> [UIBarButtonItem] {
        component?.flatMap(\.barButtonItems) ?? []
    }

    static func buildEither(first component: [ToolbarSection]) -> [UIBarButtonItem] {
        component.flatMap(\.barButtonItems)
    }

    static func buildEither(second component: [ToolbarSection]) -> [UIBarButtonItem] {
        component.flatMap(\.barButtonItems)
    }
}

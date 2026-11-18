//  Created by Geoff Pado on 12/6/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

public protocol BarSection {
    @MainActor var barButtonItems: [UIBarButtonItem] { get }
}

extension UIBarButtonItem: BarSection {
    public var barButtonItems: [UIBarButtonItem] { [self] }
}

extension Array: BarSection where Element == UIBarButtonItem {
    public var barButtonItems: [UIBarButtonItem] { self }
}

@MainActor @resultBuilder
public struct BarBuilder {
    public static func buildBlock(_ components: any BarSection...) -> [UIBarButtonItem] {
        components.flatMap(\.barButtonItems)
    }

    public static func buildOptional(_ component: [any BarSection]?) -> [UIBarButtonItem] {
        component?.flatMap(\.barButtonItems) ?? []
    }

    public static func buildEither(first component: [any BarSection]) -> [UIBarButtonItem] {
        component.flatMap(\.barButtonItems)
    }

    public static func buildEither(second component: [any BarSection]) -> [UIBarButtonItem] {
        component.flatMap(\.barButtonItems)
    }
}

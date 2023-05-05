//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

public extension URL {
    func isParent(of potentialChild: URL) -> Bool {
        potentialChild.absoluteURL.pathComponents.starts(with: absoluteURL.pathComponents)
    }

    func isChild(of potentialParent: URL) -> Bool {
        absoluteURL.pathComponents.starts(with: potentialParent.absoluteURL.pathComponents)
    }
}

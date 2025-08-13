//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public protocol Expectation: Sendable {
    func fulfill()
}

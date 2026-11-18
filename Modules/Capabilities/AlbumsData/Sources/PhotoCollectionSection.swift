//  Created by Geoff Pado on 7/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public struct PhotoCollectionSection {
    public let title: String
    public let collections: [any PhotoCollection]

    public init(title: String, collections: [any PhotoCollection]) {
        self.title = title
        self.collections = collections
    }
}

//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import FactoryKit

protocol ImageLoaderFactory {
    func newImageLoader() -> any ImageLoader
}

extension Container {
    var imageLoaderFactory: Factory<any ImageLoaderFactory> {
        Factory(self) {
            AssetImageLoader.Factory()
        }
    }
}

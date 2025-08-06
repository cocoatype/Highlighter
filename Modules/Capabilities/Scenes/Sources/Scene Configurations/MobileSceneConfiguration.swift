//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if !targetEnvironment(macCatalyst)
class MobileSceneConfiguration: WindowSceneConfiguration {
    init() {
        super.init(name: "Highlighter")
    }
}
#endif

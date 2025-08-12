//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

@MainActor protocol ListViewDelegate: AnyObject {
    var autoRedactionWordsCount: Int { get }
    func autoRedactionWord(at index: IndexPath) -> String
}

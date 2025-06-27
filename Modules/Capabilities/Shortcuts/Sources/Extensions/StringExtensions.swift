//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation
import UniformTypeIdentifiers

extension String {
    var deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }

    func appendingPathExtension(for type: UTType) -> String {
        (self as NSString).appendingPathExtension(for: type)
    }
}

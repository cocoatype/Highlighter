//  Created by Geoff Pado on 9/19/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

protocol SecureResource {
    func startAccessingSecurityScopedResource() -> Bool
    func stopAccessingSecurityScopedResource()
    var data: Data { get throws }
}

extension URL: SecureResource {
    var data: Data {
        get throws {
            try Data(contentsOf: self)
        }
    }
}

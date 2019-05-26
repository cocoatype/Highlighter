//  Created by Geoff Pado on 5/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

struct AppLookupResponse: Decodable {
    private let results: [AppLookupResponseResult]
    var developerInfo: AppDeveloperInfo? {
        return results.compactMap { result -> AppDeveloperInfo? in
            switch result {
            case .developerInfo(let info): return info
            case .appEntry, .unknown: return nil
            }
        }.first
    }

    var appEntries: [AppEntry] {
        return results.compactMap { result -> AppEntry? in
            switch result {
            case .appEntry(let app): return app
            case .developerInfo, .unknown: return nil
            }
        }
    }
}

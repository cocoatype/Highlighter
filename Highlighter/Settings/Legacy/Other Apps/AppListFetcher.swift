//  Created by Geoff Pado on 5/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class AppListFetcher: NSObject {
    func fetchAppEntries(completionHandler: (@escaping ([AppEntry]?, Error?) -> Void)) {
        guard let lookupURL = AppListFetcher.appEntriesLookupURL else {
            completionHandler(nil, FetchError.failedToConstructURL)
            return
        }

        URLSession.shared.dataTask(with: lookupURL) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }

            do {
                let response = try JSONDecoder().decode(AppLookupResponse.self, from: data)

                // filter out this app from the apps list
                let bundleID = Bundle.main.bundleIdentifier ?? "com.cocoatype.Highlighter"
                let otherApps = response.appEntries.filter { $0.bundleID != bundleID }

                completionHandler(otherApps, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }

    enum FetchError: Error {
        case failedToConstructURL
    }

    // MARK: Boilerplate

    private static let developerID = "284919238"
    private static var appEntriesLookupURL: URL? {
        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        components?.queryItems = [
            URLQueryItem(name: "id", value: developerID),
            URLQueryItem(name: "entity", value: "software")
        ]
        return components?.url
    }
}

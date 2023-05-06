//  Created by Geoff Pado on 5/1/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

public class RestorationImageCache: NSObject {
    static let shared = RestorationImageCache()

    func writeImageToCache(_ image: UIImage, fileName: String?, completion: @escaping ((Result<URL, Swift.Error>) -> Void)) {
        operationQueue.addOperation { [weak self] in
            guard let cache = self,
                  let data = image.pngData()
            else { return completion(.failure(Error.noImageData)) }

            let hash = String(format: "%llx", data.hashValue)
            let url = cache.directoryURL.appendingPathComponent(fileName ?? hash)

            do {
                try data.write(to: url, options: .atomic)
                completion(.success(url))
            } catch { completion(.failure(error)) }
        }
    }

    public func readImageFromCache(at url: URL, completion: @escaping ((Result<UIImage, Swift.Error>) -> Void)) {
        operationQueue.addOperation {
            do {
                let imageData = try Data(contentsOf: url)
                guard let image = UIImage(data: imageData) else {
                    return completion(.failure(Error.invalidImageData))
                }
                completion(.success(image))
            } catch { completion(.failure(error)) }
        }
    }

    private let operationQueue = OperationQueue()
    private let directoryURL: URL = {
        do {
            return try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch { ErrorHandler().crash("Error creating caches directory: \(error.localizedDescription)") }
    }()

    enum Error: Swift.Error {
        case noImageData
        case invalidImageData
        case securityScopeNotGranted
    }
}

public protocol FileURLProvider {
    var representedFileURL: URL? { get }
    func updateRepresentedFileURL(to newURL: URL)
}

extension FileURLProvider {
    var representedFileName: String? { representedFileURL?.lastPathComponent }
}

public extension UIResponder {
    var fileURLProvider: FileURLProvider? {
        if let provider = (self as? FileURLProvider) {
            return provider
        }

        return next?.fileURLProvider
    }
}

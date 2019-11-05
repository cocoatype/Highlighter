//  Created by Geoff Pado on 11/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class ImageDownloader: NSObject {
    func downloadImage(at url: URL, to imageView: UIImageView) {
        let downloadTask = session.dataTask(with: url) { (data, _, _) in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        store(downloadTask, for: imageView)
        downloadTask.resume()
    }

    func cancelDownloadTask(for imageView: UIImageView) {
        guard let currentTask = downloadTasks[imageView] else { return }
        currentTask.cancel()
    }

    private func store(_ downloadTask: URLSessionDataTask, for imageView: UIImageView) {
        cancelDownloadTask(for: imageView)
        downloadTasks[imageView] = downloadTask
    }

    private var downloadTasks = [UIImageView: URLSessionDataTask]()
    private var session: URLSession { return URLSession.shared }
}

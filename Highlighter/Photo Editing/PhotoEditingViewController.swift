//  Created by Geoff Pado on 4/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import os.log
import Photos
import UIKit
import Vision

class PhotoEditingViewController: UIViewController {
    init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AppViewController.dismissPhotoEditingViewController))
    }

    override func loadView() {
        view = PhotoEditingView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { [weak self] image, info in
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
            guard let image = image, isDegraded == false else { return }

            self?.textRectangleDetector.detectTextRectangles(in: image) { (textObservations) in
                dump(textObservations)
            }

            DispatchQueue.main.async { [weak self] in
                self?.photoEditingView?.image = image
            }
        }
    }

    // MARK: Boilerplate

    private let asset: PHAsset
    private let imageManager = PHImageManager()
    private var photoEditingView: PhotoEditingView? { return view as? PhotoEditingView }
    private let textRectangleDetector = TextRectangleDetector()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class TextRectangleDetector: NSObject {
    func detectTextRectangles(in image: UIImage, completionHandler: (([VNTextObservation]?) -> Void)? = nil) {
        guard let detectionOperation = TextRectangleDetectionOperation(image: image) else {
            completionHandler?(nil)
            return
        }

        detectionOperation.completionBlock = { [weak detectionOperation] in
            completionHandler?(detectionOperation?.textRectangleResults)
        }

        operationQueue.addOperation(detectionOperation)
    }

    // MARK: Boilerplate

    private let operationQueue = OperationQueue()
}

class TextRectangleDetectionOperation: Operation {
    init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        self.imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.imageOrientation.cgImagePropertyOrientation)

        super.init()
    }

    var textRectangleResults: [VNTextObservation]?

    override func start() {
        let imageRequest = VNDetectTextRectanglesRequest { [weak self] request, error in
            guard let textObservations = (request.results as? [VNTextObservation]) else {
                TextRectangleDetectionOperation.log("error getting text rectangles: \(error?.localizedDescription ?? "(null)")", type: .error)
                self?._finished = true
                self?._executing = false
                return
            }

            self?.textRectangleResults = textObservations
            self?._finished = true
            self?._executing = false
        }

        do {
            try imageRequestHandler.perform([imageRequest])
            _executing = true
        } catch {
            TextRectangleDetectionOperation.log("error starting image request: \(error.localizedDescription)", type: .error)
            _finished = true
            _executing = false
        }
    }

    // MARK: Logging

    static var log: OSLog { return OSLog(subsystem: "com.cocoatype.Highlighter", category: "Text Detection") }
    static func log(_ text: String, type: OSLogType = .default) {
        os_log("%@", log: TextRectangleDetectionOperation.log, type: type, text)
    }

    // MARK: Boilerplate

    private let imageRequestHandler: VNImageRequestHandler

    override var isAsynchronous: Bool { return true }

    private var _executing = false {
        willSet {
            willChangeValue(for: \.isExecuting)
        }

        didSet {
            didChangeValue(for: \.isExecuting)
        }
    }
    override var isExecuting: Bool { return _executing }

    private var _finished = false {
        willSet {
            willChangeValue(for: \.isFinished)
        }

        didSet {
            didChangeValue(for: \.isFinished)
        }
    }
    override var isFinished: Bool { return _finished }
}

extension UIImage.Orientation {
    var cgImagePropertyOrientation: CGImagePropertyOrientation {
        switch self {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}

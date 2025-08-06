//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import VisionKit

public protocol DocumentCameraViewController: UIViewController {
    var delegate: VNDocumentCameraViewControllerDelegate? { get set }
}

extension VNDocumentCameraViewController: DocumentCameraViewController {}

class StubDocumentCameraViewController: UIViewController, DocumentCameraViewController {
    weak var delegate: VNDocumentCameraViewControllerDelegate?
}

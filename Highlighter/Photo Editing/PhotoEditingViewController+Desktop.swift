//  Created by Geoff Pado on 8/10/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit
import UniformTypeIdentifiers

#if targetEnvironment(macCatalyst)
extension PhotoEditingViewController {
    private var imageType: UTType? {
        guard let imageTypeString = image?.cgImage?.utType
        else { return nil }

        return UTType(imageTypeString as String)
    }

    @objc func save(_ sender: Any) {
        guard let exportURL = view.window?.windowScene?.titlebar?.representedURL, let imageType = imageType else { return }

        exportImage { [weak self] image in
            let data: Data?

            switch imageType {
            case .jpeg:
                data = image?.jpegData(compressionQuality: 0.9)
            case .png: fallthrough
            default:
                data = image?.pngData()
            }

            guard let exportData = data else { return }
            do {
                try exportData.write(to: exportURL)
                self?.clearHasMadeEdits()
            } catch {}
        }
    }

    var canSave: Bool {
        guard let imageType = imageType else { return false }
        guard hasMadeEdits == true else { return false }
        return [UTType.png, .jpeg].contains(imageType)
    }
}
#endif

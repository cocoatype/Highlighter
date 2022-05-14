//  Created by Geoff Pado on 10/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import UniformTypeIdentifiers

enum RedactActionInput {
    case string(String),
         url(URL),
         data(Data)

    var fileType: UTType? {
        let fileURL: URL
        switch self {
        case .string(let string): fileURL = URL(fileURLWithPath: string)
        case .url(let url): fileURL = url
        default: return nil
        }

        do {
            let resourceValues = try fileURL.resourceValues(forKeys: [.contentTypeKey])
            return resourceValues.contentType
        } catch { return nil }
    }

    var imageType: NSBitmapImageRep.FileType {
        switch fileType {
        case UTType.tiff: return .tiff
        case UTType.bmp: return .bmp
        case UTType.gif: return .gif
        case UTType.jpeg: return .jpeg
        case UTType.png: return .png
        default: return .png
        }
    }

    var image: NSImage? {
        switch self {
        case .string(let string): return NSImage(contentsOfFile: string)
        case .url(let url): return NSImage(contentsOf: url)
        case .data(let data): return NSImage(data: data)
        }
    }
}

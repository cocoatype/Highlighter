//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

@available(iOS 14.0, *)
struct AssetButton: View {
    init(_ asset: PHAsset, action: ((Asset) -> Void)? = nil) { self.init(Asset(asset), action: action) }
    init(_ asset: Asset, action: ((Asset) -> Void)? = nil) {
        self.asset = asset
        self.action = action
    }

    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            Button(action: {
                action?(asset)
            }) {
                if let image = asset.image {
                    Image(uiImage: image).renderingMode(.original).resizable().aspectRatio(contentMode: .fill).frame(width: proxy.size.width, height: proxy.size.height).clipped()
                } else {
                    Color.gray
                }
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
    
    @ObservedObject private var asset: Asset
    private let action: ((Asset) -> Void)?
}

@available(iOS 14.0, *)
class Asset: ObservableObject {
    @Published var image: UIImage?
    let photoAsset: PHAsset
    init(_ asset: PHAsset) {
        self.photoAsset = asset
        
        fetchImage { [weak self] fetchedImage in
            self?.image = fetchedImage
        }
    }
    
    // MARK: Image Loading

    static let imageManager = PHImageManager.default()

    func fetchImage(completionHandler: @escaping ((UIImage?) -> Void)) {
        Self.imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: photoAsset.pixelWidth, height: photoAsset.pixelHeight), contentMode: .aspectFill, options: nil) { image, _ in
            completionHandler(image)
        }
    }
}

@available(iOS 14.0, *)
struct AssetButton_Previews: PreviewProvider {
    class PreviewAsset: Asset {
        init() {
            super.init(PHAsset())
        }

        override func fetchImage(completionHandler: @escaping ((UIImage?) -> Void)) {
            let image = UIImage(named: "sample")!
            completionHandler(image)
        }
    }
    static let asset = PreviewAsset()
    static var previews: some View {
        Group {
            AssetButton(asset).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            AssetButton(asset).frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

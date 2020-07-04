//  Created by Geoff Pado on 7/1/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI

@available(iOS 14.0, *)
struct AssetButton: View {
    init(_ asset: PHAsset) { self.init(Asset(asset)) }
    init(_ asset: Asset) {
        self.asset = asset
    }

    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            if let image = asset.image {
                Image(uiImage: image).resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/).frame(width: proxy.size.width, height: proxy.size.height).clipped()
            } else {
                Color.gray
            }
        }
    }
    
    @ObservedObject private var asset: Asset
}

@available(iOS 14.0, *)
class Asset: ObservableObject {
    @Published var image: UIImage?
    private var asset: PHAsset
    init(_ asset: PHAsset) {
        self.asset = asset
        
        fetchImage { [weak self] fetchedImage in
            self?.image = fetchedImage
        }
    }
    
    // MARK: Image Loading

    static let imageManager = PHImageManager.default()

    func fetchImage(completionHandler: @escaping ((UIImage?) -> Void)) {
        Self.imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { image, _ in
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

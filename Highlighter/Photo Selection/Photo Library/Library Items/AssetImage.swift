//  Created by Geoff Pado on 7/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

@available(iOS 14.0, *)
struct AssetImage: View {
    init(_ image: UIImage, size: CGSize) {
        self.image = image
        self.size = size
    }

    var body: some View {
        Image(uiImage: image)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipped()
    }

    private let image: UIImage
    private let size: CGSize
}

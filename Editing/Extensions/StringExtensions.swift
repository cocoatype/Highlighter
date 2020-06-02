//  Created by Geoff Pado on 5/29/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

public extension String {
    var words: [(String, Range<String.Index>)] {
        var words = [(String, Range<String.Index>)]()
        enumerateSubstrings(in: startIndex..<endIndex, options: [.byWords]) { word, wordRange, _, _ in
            guard let word = word else { return }
            words.append((word, wordRange))
        }

        return words
    }
}

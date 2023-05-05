//  Created by Geoff Pado on 5/29/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

public class StringTagger: NSObject {
    public static func detectNames(in fullTextString: String) -> [Substring] {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = fullTextString
        let range = NSRange(location: 0, length: fullTextString.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        let tags = [NSLinguisticTag.personalName]

        var taggedWordList = [Substring]()
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { (tag, tokenRange, _) in
            guard let tag = tag, tags.contains(tag) else { return }
            let name = fullTextString.substring(with: tokenRange)
            taggedWordList.append(name)
        }

        return taggedWordList
    }

    public static func detectAddresses(in fullTextString: String) -> [Substring] {
        return detect(.address, in: fullTextString)
    }

//    private static func strings(from addressResult: [NSTextCheckingKey : String]?) -> [Substring] {
//        guard let addressResult = addressResult else { return [] }
//        return addressResult.values.flatMap { $0.words }.map { $0.0 }
//    }

    public static func detectPhoneNumbers(in fullTextString: String) -> [Substring] {
        return detect(.phoneNumber, in: fullTextString)
    }

    private static func detect(_ resultType: NSTextCheckingResult.CheckingType, in fullTextString: String) -> [Substring] {
        do {
            let detector = try NSDataDetector(types: resultType.rawValue)
            let range = NSRange(location: 0, length: fullTextString.utf16.count)
            return detector.matches(in: fullTextString, range: range).flatMap { match -> [Substring] in
                (0..<match.numberOfRanges).map { index in
                    let range = match.range(at: index)
                    return fullTextString.substring(with: range)
                }
            }
        } catch {
            return []
        }
    }
}

extension String {
    func substring(with range: NSRange) -> Substring {
        let substringStartIndex = String.Index(utf16Offset: range.location, in: self)
        let substringEndIndex = String.Index(utf16Offset: range.location + range.length, in: self)
        let substringRange = substringStartIndex ..< substringEndIndex
        return self[substringRange]
    }
}

//  Created by Geoff Pado on 5/29/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

import ErrorHandling

public class StringTagger: NSObject {
    public static func detectNames(in fullTextString: String) -> [Substring] {
        nameRanges(in: fullTextString).map(fullTextString.substring(with:))
    }

    public static func detectAddresses(in fullTextString: String) -> [Substring] {
        addressRanges(in: fullTextString).map(fullTextString.substring(with:))
    }

    public static func detectPhoneNumbers(in fullTextString: String) -> [Substring] {
        phoneNumberRanges(in: fullTextString).map(fullTextString.substring(with:))
    }

    // MARK: Ranges

    static func nameRanges(in fullTextString: String) -> [NSRange] {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = fullTextString
        let range = NSRange(location: 0, length: fullTextString.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        let tags = [NSLinguisticTag.personalName]

        var taggedRanges = [NSRange]()
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
            guard let tag = tag, tags.contains(tag) else { return }
            taggedRanges.append(tokenRange)
        }

        return taggedRanges
    }

    static func addressRanges(in fullTextString: String) -> [NSRange] {
        ranges(of: .address, in: fullTextString)
    }

    static func phoneNumberRanges(in fullTextString: String) -> [NSRange] {
        ranges(of: .phoneNumber, in: fullTextString)
    }

    private static func ranges(of resultType: NSTextCheckingResult.CheckingType, in fullTextString: String) -> [NSRange] {
        do {
            let detector = try NSDataDetector(types: resultType.rawValue)
            let range = NSRange(location: 0, length: fullTextString.utf16.count)
            return detector.matches(in: fullTextString, range: range).flatMap { match -> [NSRange] in
                (0..<match.numberOfRanges).map(match.range(at:))
            }
        } catch {
            Container.shared.errorHandler()
                .log(error, module: "Detections", type: "StringTagger")
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

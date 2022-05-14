//  Created by Geoff Pado on 5/29/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation

class StringTagger: NSObject {
    static func detectNames(in fullTextString: String) -> [String] {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = fullTextString
        let range = NSRange(location: 0, length: fullTextString.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        let tags = [NSLinguisticTag.personalName]

        var taggedWordList = [String]()
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { (tag, tokenRange, _) in
            guard let tag = tag, tags.contains(tag) else { return }
            let name = (fullTextString as NSString).substring(with: tokenRange)
            taggedWordList.append(name)
        }

        return taggedWordList
    }

    static func detectAddresses(in fullTextString: String) -> [String] {
        return detect(.address, in: fullTextString)
    }

    private static func strings(from addressResult: [NSTextCheckingKey : String]?) -> [String] {
        guard let addressResult = addressResult else { return [] }
        return addressResult.values.flatMap { $0.words }.map { $0.0 }
    }

    static func detectPhoneNumbers(in fullTextString: String) -> [String] {
        return detect(.phoneNumber, in: fullTextString)
    }

    private static func detect(_ resultType: NSTextCheckingResult.CheckingType, in fullTextString: String) -> [String] {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
            let range = NSRange(location: 0, length: fullTextString.utf16.count)
            return detector.matches(in: fullTextString, range: range).flatMap { match -> [String] in
                switch match.resultType {
                case .address: return strings(from: match.addressComponents)
                case .phoneNumber: return [match.phoneNumber].compactMap { $0 }
                default: return []
                }
            }
        } catch {
            return []
        }
    }
}

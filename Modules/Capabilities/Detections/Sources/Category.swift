//  Created by Geoff Pado on 5/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation

public enum Category: CaseIterable, Sendable {
    case names
    case addresses
    case phoneNumbers

    // getFuncyInSwizzleTown by @mono_nz on 2024-05-31
    // the tagging function for this category
    public var getFuncyInSwizzleTown: (String) -> [Substring] {
        switch self {
        case .addresses: return StringTagger.detectAddresses(in:)
        case .names: return StringTagger.detectNames(in:)
        case .phoneNumbers: return StringTagger.detectPhoneNumbers(in:)
        }
    }

    var rangeFunction: (String) -> [NSRange] {
        switch self {
        case .addresses: return StringTagger.addressRanges(in:)
        case .names: return StringTagger.nameRanges(in:)
        case .phoneNumbers: return StringTagger.phoneNumberRanges(in:)
        }
    }

    /// Tags all of the given lines together, so each line has the others as
    /// context, and returns matches relative to the line they came from.
    ///
    /// - Parameters:
    ///   - categories: The categories to detect.
    ///   - lines: The lines of the document, in reading order.
    public static func detections(for categories: [Category], in lines: [TaggableLine]) -> [DetectedSpan] {
        guard categories.isEmpty == false, lines.isEmpty == false else { return [] }
        let document = TaggableDocument(lines: lines)
        return categories.flatMap { category in
            category.rangeFunction(document.text).flatMap { match in
                document.spans(for: match, category: category)
            }
        }
    }

    public func detections(in lines: [TaggableLine]) -> [DetectedSpan] {
        Self.detections(for: [self], in: lines)
    }
}

//  Created by Geoff Pado on 10/31/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation

/// A single line of recognized text that can be tagged as part of a larger document.
public struct TaggableLine: Equatable, Sendable {
    public let id: UUID
    public let text: String

    public init(id: UUID, text: String) {
        self.id = id
        self.text = text
    }
}

/// A tagged range, expressed relative to the line it was found in.
public struct DetectedSpan: Equatable, Sendable {
    public let category: Category
    public let lineID: UUID
    public let range: Range<String.Index>

    public init(category: Category, lineID: UUID, range: Range<String.Index>) {
        self.category = category
        self.lineID = lineID
        self.range = range
    }
}

/// Joins lines of text into a single string for tagging, and maps ranges in
/// that string back to the lines they came from.
struct TaggableDocument {
    static let defaultSeparator = "\n"

    let text: String
    private let lines: [(line: TaggableLine, utf16Range: Range<Int>)]

    init(lines: [TaggableLine], separator: String = Self.defaultSeparator) {
        var text = ""
        var mappedLines = [(line: TaggableLine, utf16Range: Range<Int>)]()
        mappedLines.reserveCapacity(lines.count)

        for (index, line) in lines.enumerated() {
            if index > 0 { text += separator }
            let start = text.utf16.count
            text += line.text
            mappedLines.append((line, start ..< text.utf16.count))
        }

        self.text = text
        self.lines = mappedLines
    }

    var fullRange: NSRange {
        NSRange(location: 0, length: text.utf16.count)
    }

    /// Splits a range in the document's text into line-local ranges.
    ///
    /// A match that spans several lines produces one span per line. Parts of
    /// the match that only cover separators are dropped.
    func spans(for match: NSRange, category: Category) -> [DetectedSpan] {
        guard match.location != NSNotFound, match.length > 0 else { return [] }
        let matchRange = match.location ..< (match.location + match.length)

        return lines.compactMap { line, lineRange in
            let lower = max(matchRange.lowerBound, lineRange.lowerBound)
            let upper = min(matchRange.upperBound, lineRange.upperBound)
            guard lower < upper else { return nil }

            let lineText = line.text
            let start = String.Index(utf16Offset: lower - lineRange.lowerBound, in: lineText)
            let end = String.Index(utf16Offset: upper - lineRange.lowerBound, in: lineText)
            return DetectedSpan(category: category, lineID: line.id, range: start ..< end)
        }
    }
}

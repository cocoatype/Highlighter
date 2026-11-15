//  Created by Geoff Pado on 10/31/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation
import Testing

@testable import Detections

struct TaggableDocumentTests {
    @Test func joinsLinesWithSeparator() {
        let document = TaggableDocument(lines: [
            TaggableLine(id: UUID(), text: "Hello"),
            TaggableLine(id: UUID(), text: "world"),
        ])

        #expect(document.text == "Hello\nworld")
    }

    @Test func emptyDocumentHasEmptyText() {
        let document = TaggableDocument(lines: [])
        #expect(document.text.isEmpty)
        #expect(document.spans(for: NSRange(location: 0, length: 0), category: .names).isEmpty)
    }

    @Test func matchInsideOneLineMapsToThatLine() throws {
        let first = TaggableLine(id: UUID(), text: "Call me at")
        let second = TaggableLine(id: UUID(), text: "work 555-0101 today")
        let document = TaggableDocument(lines: [first, second])

        let match = (document.text as NSString).range(of: "555-0101")
        let spans = document.spans(for: match, category: .phoneNumbers)

        let span = try #require(spans.first)
        #expect(spans.count == 1)
        #expect(span.lineID == second.id)
        #expect(span.category == .phoneNumbers)
        #expect(second.text[span.range] == "555-0101")
    }

    @Test func matchAcrossLinesIsSplitPerLine() {
        let first = TaggableLine(id: UUID(), text: "1 Infinite Loop")
        let second = TaggableLine(id: UUID(), text: "Cupertino, CA 95014")
        let document = TaggableDocument(lines: [first, second])

        let spans = document.spans(for: document.fullRange, category: .addresses)

        #expect(spans.map(\.lineID) == [first.id, second.id])
        #expect(first.text[spans[0].range] == "1 Infinite Loop")
        #expect(second.text[spans[1].range] == "Cupertino, CA 95014")
    }

    @Test func partialMatchAcrossLinesIsClampedToEachLine() {
        let first = TaggableLine(id: UUID(), text: "Name: Jane")
        let second = TaggableLine(id: UUID(), text: "Doe is here")
        let document = TaggableDocument(lines: [first, second])

        let match = (document.text as NSString).range(of: "Jane\nDoe")
        let spans = document.spans(for: match, category: .names)

        #expect(spans.count == 2)
        #expect(first.text[spans[0].range] == "Jane")
        #expect(second.text[spans[1].range] == "Doe")
    }

    @Test func matchCoveringOnlySeparatorIsDropped() {
        let document = TaggableDocument(lines: [
            TaggableLine(id: UUID(), text: "abc"),
            TaggableLine(id: UUID(), text: "def"),
        ])

        let spans = document.spans(for: NSRange(location: 3, length: 1), category: .names)
        #expect(spans.isEmpty)
    }

    @Test func emptyAndNotFoundMatchesAreDropped() {
        let document = TaggableDocument(lines: [TaggableLine(id: UUID(), text: "abc")])

        #expect(document.spans(for: NSRange(location: 1, length: 0), category: .names).isEmpty)
        #expect(document.spans(for: NSRange(location: NSNotFound, length: 0), category: .names).isEmpty)
    }

    @Test func emptyLinesKeepLaterOffsetsCorrect() throws {
        let empty = TaggableLine(id: UUID(), text: "")
        let target = TaggableLine(id: UUID(), text: "hello there")
        let document = TaggableDocument(lines: [empty, empty, target])

        let match = (document.text as NSString).range(of: "there")
        let span = try #require(document.spans(for: match, category: .names).first)

        #expect(span.lineID == target.id)
        #expect(target.text[span.range] == "there")
    }

    @Test func nonBMPCharactersBeforeMatchKeepOffsetsCorrect() throws {
        let first = TaggableLine(id: UUID(), text: "👋🏽 Jen 🏀")
        let second = TaggableLine(id: UUID(), text: "🇺🇸 (206) 555-0101")
        let document = TaggableDocument(lines: [first, second])

        let firstMatch = (document.text as NSString).range(of: "Jen")
        let firstSpan = try #require(document.spans(for: firstMatch, category: .names).first)
        #expect(first.text[firstSpan.range] == "Jen")

        let secondMatch = (document.text as NSString).range(of: "(206) 555-0101")
        let secondSpan = try #require(document.spans(for: secondMatch, category: .phoneNumbers).first)
        #expect(second.text[secondSpan.range] == "(206) 555-0101")
    }

    @Test func customSeparatorIsUsed() throws {
        let first = TaggableLine(id: UUID(), text: "a")
        let second = TaggableLine(id: UUID(), text: "bc")
        let document = TaggableDocument(lines: [first, second], separator: " | ")

        #expect(document.text == "a | bc")

        let span = try #require(document.spans(for: NSRange(location: 4, length: 2), category: .names).first)
        #expect(span.lineID == second.id)
        #expect(second.text[span.range] == "bc")
    }
}

struct CategoryDetectionsTests {
    @Test func phoneNumberIsAttributedToItsLine() throws {
        let first = TaggableLine(id: UUID(), text: "hello")
        let second = TaggableLine(id: UUID(), text: "(206) 555-0101")

        let spans = Category.phoneNumbers.detections(in: [first, second])

        let span = try #require(spans.first)
        #expect(spans.count == 1)
        #expect(span.lineID == second.id)
        #expect(second.text[span.range] == "(206) 555-0101")
    }

    @Test func addressSpanningLinesIsAttributedToBothLines() {
        let first = TaggableLine(id: UUID(), text: "1 Infinite Loop")
        let second = TaggableLine(id: UUID(), text: "Cupertino, CA 95014")

        let spans = Category.addresses.detections(in: [first, second])

        #expect(Set(spans.map(\.lineID)) == [first.id, second.id])
        #expect(spans.allSatisfy { $0.category == .addresses })
    }

    @Test func multipleCategoriesAreTaggedTogether() {
        let first = TaggableLine(id: UUID(), text: "(206) 555-0101")
        let second = TaggableLine(id: UUID(), text: "1 Infinite Loop")
        let third = TaggableLine(id: UUID(), text: "Cupertino, CA 95014")

        let spans = Category.detections(for: [.phoneNumbers, .addresses], in: [first, second, third])

        #expect(spans.contains { $0.category == .phoneNumbers && $0.lineID == first.id })
        #expect(spans.contains { $0.category == .addresses && $0.lineID == third.id })
    }

    @Test func noCategoriesOrLinesReturnsNothing() {
        #expect(Category.detections(for: [], in: [TaggableLine(id: UUID(), text: "(206) 555-0101")]).isEmpty)
        #expect(Category.detections(for: Category.allCases, in: []).isEmpty)
    }

    @Test func perStringAPIMatchesSingleLineDetections() {
        let text = "Call (206) 555-0101 now"
        let line = TaggableLine(id: UUID(), text: text)

        let legacy = Category.phoneNumbers.getFuncyInSwizzleTown(text).map(String.init)
        let current = Category.phoneNumbers.detections(in: [line]).map { String(text[$0.range]) }

        #expect(legacy == current)
    }
}

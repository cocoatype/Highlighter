//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import CoreGraphics
import Foundation
import Testing

import FactoryKit
import FactoryTesting

import Geometry
import Observations

@testable import EditingEngine

@Suite(.container)
struct ObservationCalculatorTests {
    private static let parentRect = CGRect(x: 0, y: 0, width: 10, height: 10)

    @Test func combinesFilledParentWithItsChildren() async {
        let parent = observation(Self.parentRect)
        let leftChild = observation(CGRect(x: 0, y: 0, width: 5, height: 10))
        let rightChild = observation(CGRect(x: 5, y: 0, width: 5, height: 10))

        let calculated = await calculate(detected: [leftChild, rightChild], recognized: [parent])

        let expected = CharacterObservation(
            bounds: MinimumAreaShapeFinder.minimumAreaShape(for: [leftChild.bounds, rightChild.bounds]),
            textObservationUUID: parent.textObservationUUID
        )
        #expect(calculated == [expected])
    }

    @Test func keepsUnfilledParentAndDropsItsChildren() async {
        let parent = observation(Self.parentRect)
        let smallChild = observation(CGRect(x: 0, y: 0, width: 2, height: 2))

        let calculated = await calculate(detected: [smallChild], recognized: [parent])

        #expect(calculated == [parent])
    }

    @Test func keepsChildlessRecognizedAndOrphanedDetectedObservations() async {
        let recognized = observation(Self.parentRect)
        let detected = observation(CGRect(x: 50, y: 50, width: 10, height: 10))

        let calculated = await calculate(detected: [detected], recognized: [recognized])

        #expect(Set(calculated) == [recognized, detected])
    }

    @Test func ignoresZeroSizedObservations() async {
        let zeroShape = Shape(bottomLeft: .zero, bottomRight: .zero, topLeft: .zero, topRight: .zero)
        let zero = CharacterObservation(bounds: zeroShape, textObservationUUID: UUID())

        let calculated = await calculate(detected: [zero], recognized: [zero])

        #expect(calculated.isEmpty)
    }

    @Test func usesInjectedIntersectionFinder() async {
        Container.shared.intersectionFinder.register { StubIntersectionFinder(result: true) }
        let parent = observation(Self.parentRect)
        let farChild = observation(CGRect(x: 50, y: 50, width: 10, height: 10))

        let calculated = await calculate(detected: [farChild], recognized: [parent])

        #expect(calculated.map(\.textObservationUUID) == [parent.textObservationUUID])
    }

    @Test func groupsCalculatedObservationsByUUID() async {
        let first = observation(Self.parentRect)
        let second = observation(CGRect(x: 50, y: 50, width: 10, height: 10))

        let calculator = ObservationCalculator(detectedCharacterObservations: [], recognizedCharacterObservations: [first, second])
        let byUUID = await calculator.calculatedObservationsByUUID

        #expect(byUUID == [first.textObservationUUID: [first], second.textObservationUUID: [second]])
    }

    // MARK: Helpers

    private func calculate(detected: [CharacterObservation], recognized: [CharacterObservation]) async -> [CharacterObservation] {
        let calculator = ObservationCalculator(detectedCharacterObservations: detected, recognizedCharacterObservations: recognized)
        return await calculator.calculatedObservations
    }

    private func observation(_ rect: CGRect) -> CharacterObservation {
        CharacterObservation(bounds: Shape(rect), textObservationUUID: UUID())
    }
}

struct SystemIntersectionFinderTests {
    private let base = Shape(CGRect(x: 0, y: 0, width: 10, height: 10)).path

    @available(iOS 16.0, macOS 13.0, *)
    @Test func findsIntersectionCoveringMostOfFirstPath() {
        let finder = SystemIntersectionFinder()
        let other = Shape(CGRect(x: 2, y: 0, width: 10, height: 10)).path
        #expect(finder.intersectionExists(between: base, and: other))
    }

    @available(iOS 16.0, macOS 13.0, *)
    @Test func ignoresIntersectionCoveringLessThanHalfOfFirstPath() {
        let finder = SystemIntersectionFinder()
        let other = Shape(CGRect(x: 8, y: 0, width: 10, height: 10)).path
        #expect(finder.intersectionExists(between: base, and: other) == false)
    }

    @available(iOS 16.0, macOS 13.0, *)
    @Test func ignoresDisjointPaths() {
        let finder = SystemIntersectionFinder()
        let other = Shape(CGRect(x: 50, y: 50, width: 10, height: 10)).path
        #expect(finder.intersectionExists(between: base, and: other) == false)
    }
}

private struct StubIntersectionFinder: IntersectionFinder {
    let result: Bool
    func intersectionExists(between lhs: CGPath, and rhs: CGPath) -> Bool { result }
}

private extension Shape {
    init(_ rect: CGRect) {
        self.init(
            bottomLeft: CGPoint(x: rect.minX, y: rect.maxY),
            bottomRight: CGPoint(x: rect.maxX, y: rect.maxY),
            topLeft: CGPoint(x: rect.minX, y: rect.minY),
            topRight: CGPoint(x: rect.maxX, y: rect.minY)
        )
    }
}

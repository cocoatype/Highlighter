//  Created by Geoff Pado on 4/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

@_implementationOnly import ClippingBezier
import Logging
import Observations
import Redactions
import Tools
import UIKit

class PhotoEditingWorkspaceView: UIControl, UIGestureRecognizerDelegate {
    private let logger: any Logger
    init(logger: any Logger = Logging.logger) {
        self.logger = logger
        super.init(frame: .zero)
        isAccessibilityElement = false
        backgroundColor = .appBackground
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(visualizationView)
        addSubview(debugView)
        addSubview(redactionView)
        addSubview(brushStrokeView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            visualizationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            visualizationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            visualizationView.widthAnchor.constraint(equalTo: widthAnchor),
            visualizationView.heightAnchor.constraint(equalTo: heightAnchor),
            debugView.centerXAnchor.constraint(equalTo: centerXAnchor),
            debugView.centerYAnchor.constraint(equalTo: centerYAnchor),
            debugView.widthAnchor.constraint(equalTo: widthAnchor),
            debugView.heightAnchor.constraint(equalTo: heightAnchor),
            redactionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            redactionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            redactionView.widthAnchor.constraint(equalTo: widthAnchor),
            redactionView.heightAnchor.constraint(equalTo: heightAnchor),
            brushStrokeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            brushStrokeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            brushStrokeView.widthAnchor.constraint(equalTo: widthAnchor),
            brushStrokeView.heightAnchor.constraint(equalTo: heightAnchor),
        ])

        brushStrokeView.addTarget(self, action: #selector(handleStrokeBegin), for: .touchDown)
        brushStrokeView.addTarget(self, action: #selector(handleStrokeCompletion), for: .touchUpInside)

        pencilDelegate.workspaceView = self
        addGestureRecognizer(switchControlGestureRecognizer)
        addInteraction(pencilDelegate.newPencilInteraction())

        if #available(iOS 17.5, *) {
            feedbackGenerator = UICanvasFeedbackGenerator(view: self)
        }
    }

    // whoDidThisOhIDidThis by @AdamWulf on 2024-07-25
    // the previously-selected highlighter tool
    var whoDidThisOhIDidThis = HighlighterTool.manual

    var highlighterTool = HighlighterTool.magic {
        didSet(oldValue) {
            brushStrokeView.tool = highlighterTool

            if oldValue != highlighterTool {
                whoDidThisOhIDidThis = oldValue
            }

            if highlighterTool == .magic {
                visualizationView.animateFullVisualization()
            }
        }
    }

    var color: UIColor = .black {
        didSet {
            brushStrokeView.color = color
            visualizationView.color = color
        }
    }

    var image: UIImage? {
        get { return imageView.image }
        set(newImage) {
            imageView.image = newImage
        }
    }

    var redactions: [Redaction] {
        return redactionView.redactions
    }

    func add(_ redactions: [Redaction]) {
        redactionView.add(redactions)
    }

    func redact(_ observations: [any TextObservation], joinSiblings: Bool) {
        if joinSiblings, let wordObservations = (observations as? [WordObservation]) {
            redactionView.add(Redaction(wordObservations, color: color))
        } else {
            observations.forEach { redact($0) }
        }
    }

    func redact<ObservationType: TextObservation>(_ textObservation: ObservationType) {
        redactionView.add(Redaction(textObservation, color: color))
    }

    func unredact<ObservationType: TextObservation>(_ textObservation: ObservationType) {
        redactionView.removeRedactions { existingRedaction in
            Redaction(textObservation, color: existingRedaction.color) == existingRedaction
        }
    }

    var textObservations: [TextRectangleObservation]? {
        get { return visualizationView.textObservations }
        set(newTextObservations) {
            visualizationView.textObservations = newTextObservations
            debugView.textObservations = newTextObservations
            updateRedactableObservations()
        }
    }

    var recognizedTextObservations: [RecognizedTextObservation]? {
        get { return visualizationView.recognizedTextObservations }
        set(newTextObservations) {
            visualizationView.recognizedTextObservations = newTextObservations
            debugView.recognizedTextObservations = newTextObservations
            updateRedactableObservations()
        }
    }

    var redactableCharacterObservations = [CharacterObservation]()

    private func updateRedactableObservations() {
        let wordObservations = recognizedTextObservations ?? []
        let textCharacterObservations = textObservations?.flatMap(\.characterObservations) ?? []
        Task.detached { [weak self] in
            let calculator = PhotoEditingObservationCalculator(detectedTextObservations: textCharacterObservations, recognizedTextObservations: wordObservations)
            let filteredTextCharacterObservations = await calculator.calculatedObservations

            await MainActor.run { [weak self] in
                self?.redactableCharacterObservations = filteredTextCharacterObservations
            }
        }
    }

    func scrollViewDidZoom(to zoomScale: CGFloat) {
        brushStrokeView.zoomScale = zoomScale
    }

    // MARK: Seek and Destroy

    var seekPreviewObservations: [CharacterObservation] {
        get { return visualizationView.seekPreviewObservations }
        set(newTextObservations) {
            visualizationView.seekPreviewObservations = newTextObservations
            if newTextObservations.count > 0 {
                visualizationView.presentPreviewVisualization()
            } else {
                visualizationView.hidePreviewVisualization()
            }
        }
    }

    // MARK: Actions

    private var feedbackGenerator: (any PhotoEditingWorkspaceFeedbackGenerator)?
    @objc func handleStrokeBegin() {
        feedbackGenerator?.prepare()
    }

    @objc func handleStrokeCompletion() {
        switch highlighterTool {
        case .magic: handleMagicStrokeCompletion()
        case .lasso: handleLassoCompletion()
        case .manual: handleManualStrokeCompletion()
        case .eraser: handleEraserCompletion()
        }

        logger.log(PhotoEditingWorkspaceViewTelemetryEventFactory().event(tool: highlighterTool, color: color))

        sendAction(#selector(PhotoEditingViewController.markHasMadeEdits), to: nil, for: nil)
    }

    private func handleMagicStrokeCompletion() {
        guard let strokePath = brushStrokeView.currentPath else { return }
        let strokeBorderPath = strokePath.strokeBorderPath
        let redactedCharacterObservations = redactableCharacterObservations
            .filter { strokeBorderPath.contains($0.bounds.center) }

        if let newRedaction = Redaction(redactedCharacterObservations, color: color) {
            redactionView.add(newRedaction)
            feedbackGenerator?.pathCompleted(at: newRedaction.paths.last?.currentPoint ?? bounds.center)
        }
    }

    private func handleLassoCompletion() {}

    private func handleManualStrokeCompletion() {
        guard let strokePath = brushStrokeView.currentPath else { return }
        redactionView.add(Redaction(path: strokePath, color: color))
    }

    private func handleEraserCompletion() {
        guard let strokePath = brushStrokeView.currentPath else { return }
        let strokeBorderPath = strokePath.strokeBorderPath
        let intersectedRedactions = redactions.filter { redaction in
            redaction.paths.contains(where: { path in
                path.strokeBorderPath.intersection(with: strokeBorderPath)?.count ?? 0 > 0
            })
        }

        redactionView.remove(intersectedRedactions)
    }

    // MARK: Accessibility

    private lazy var switchControlGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleSwitchTap))
        recognizer.delegate = self
        return recognizer
    }()

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        UIAccessibility.isSwitchControlRunning
    }

    @objc func handleSwitchTap() {
        guard UIAccessibility.isSwitchControlRunning else { return }
        let location = switchControlGestureRecognizer.location(in: self)
        let tappedElement = accessibilityElements?.first(where: { element in
            guard let accessibilityElement = element as? UIAccessibilityElement
            else { return false }

            return accessibilityElement.accessibilityFrameInContainerSpace.contains(location)
        }) as? UIAccessibilityElement

        tappedElement?.accessibilityActivate()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard UIAccessibility.isSwitchControlRunning
        else { return super.hitTest(point, with: event) }

        return self
    }

    override func accessibilityActivate() -> Bool {
        return true
    }

    // MARK: Boilerplate

    private let imageView: PhotoEditingImageView = PhotoEditingImageView()
    private let visualizationView = PhotoEditingObservationVisualizationView()
    private let debugView = PhotoEditingObservationDebugView()
    private let redactionView = PhotoEditingRedactionView()
    private let brushStrokeView = PhotoEditingPathBrushStrokeView()
    private let pencilDelegate = PhotoEditingWorkspacePencilDelegate()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

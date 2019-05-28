//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import SpriteKit
import UIKit

class PhotoEditingObservationVisualizationView: SKView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let viewSize = bounds.size
        particleEmitterScene.size = viewSize
        emitterNode?.particlePositionRange = CGVector(dx: viewSize.width, dy: viewSize.height)
        emitterNode?.position = CGPoint(x: bounds.midX, y: bounds.midY)

        if scene != particleEmitterScene {
            presentScene(particleEmitterScene)
        }
    }

    // MARK: Scene

    private static let particleName = "Magic"

    private lazy var particleEmitterScene: SKScene = {
        let scene = SKScene(size: .zero)
        scene.backgroundColor = .clear
        guard let emitterNode = SKEmitterNode(fileNamed: PhotoEditingObservationVisualizationView.particleName) else { fatalError("Could not load particle emitter") }
        scene.addChild(emitterNode)
        return scene
    }()

    private var emitterNode: SKEmitterNode? {
        return (particleEmitterScene.children.first(where: { $0 is SKEmitterNode }) as? SKEmitterNode)
    }

//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        guard let textObservations = textObservations else { return }
//
//        textObservations.forEach { observation in
//            UIColor.red.withAlphaComponent(0.3).setFill()
//            UIColor.red.setStroke()
//
//            let boundsPath = UIBezierPath(rect: observation.bounds)
//            boundsPath.fill()
//            boundsPath.stroke()
//
//            let baseColor = UIColor.blue
//            baseColor.withAlphaComponent(0.3).setFill()
//            baseColor.setStroke()
//
//            observation.characterObservations?.forEach { characterObservation in
//                let boundsPath = UIBezierPath(rect: characterObservation.bounds)
//                boundsPath.fill()
//                boundsPath.stroke()
//            }
//        }
//    }

    var textObservations: [TextObservation]? {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

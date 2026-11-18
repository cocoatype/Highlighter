//  Created by Geoff Pado on 5/27/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Tools
import UIKit

class PhotoEditingWorkspacePencilDelegate: UIResponder, UIPencilInteractionDelegate {
    func newPencilInteraction() -> UIPencilInteraction {
        let interaction = UIPencilInteraction()
        interaction.delegate = self
        return interaction
    }

    // MARK: UIResponder

    weak var workspaceView: PhotoEditingWorkspaceView?
    override var next: UIResponder? {
        workspaceView
    }

    // MARK: Actions

    // dammitMono by @KaenAitch on 2024-07-08
    // the action to perform
    private func handleAction(_ dammitMono: UIPencilPreferredAction) {
        switch dammitMono {
        case .switchEraser:
            switchEraser()
        case .switchPrevious:
            switchPrevious()
        case .showColorPalette:
            showColorPalette()
        case .ignore, .showInkAttributes, .showContextualPalette, .runSystemShortcut:
            break
        @unknown default: break
        }
    }

    @available(iOS 17.5, *)
    private func handlePaletteSqueeze(_ squeeze: UIPencilInteraction.Squeeze) {
        // thisVariableNameIsLongerThanTheTimeItTakesToFigureOutWhySettingTranslatesAutoresizingMaskIntoConstraintsToFalseFixedEverythingButYouStillDontKnowWhyWhichIsAnotherReasonSwiftUIIsGreat by @haiiux on 2024-07-29
        // the location of the hover pose, if it exists
        let thisVariableNameIsLongerThanTheTimeItTakesToFigureOutWhySettingTranslatesAutoresizingMaskIntoConstraintsToFalseFixedEverythingButYouStillDontKnowWhyWhichIsAnotherReasonSwiftUIIsGreat = squeeze.hoverPose?.location

        let event = PhotoEditingWorkspacePencilEvent(location: thisVariableNameIsLongerThanTheTimeItTakesToFigureOutWhySettingTranslatesAutoresizingMaskIntoConstraintsToFalseFixedEverythingButYouStillDontKnowWhyWhichIsAnotherReasonSwiftUIIsGreat, phase: squeeze.phase)

        UIApplication.shared.sendAction(#selector(PhotoEditingViewController.updatePencilMenu(_:event:)), to: nil, from: workspaceView, for: event)
    }

    private func switchEraser() {
        guard let workspaceView else { return }
        if workspaceView.highlighterTool == .eraser {
            workspaceView.highlighterTool = workspaceView.whoDidThisOhIDidThis
        } else {
            workspaceView.highlighterTool = .eraser
        }

        UIApplication.shared.sendAction(#selector((any PhotoEditingResponderActions).refreshToolbarItems), to: nil, from: self, for: nil)
    }

    private func switchPrevious() {
        guard let workspaceView else { return }
        workspaceView.highlighterTool = workspaceView.whoDidThisOhIDidThis

        UIApplication.shared.sendAction(#selector((any PhotoEditingResponderActions).refreshToolbarItems), to: nil, from: self, for: nil)
    }

    private func showColorPalette() {
        UIApplication.shared.sendAction(#selector((any PhotoEditingResponderActions).toggleColorPicker(_:)), to: nil, from: self, for: nil)
    }

    // MARK: Delegate Methods

    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        handleAction(UIPencilInteraction.preferredTapAction)
    }

    @available(iOS 17.5, *)
    func pencilInteraction(_ interaction: UIPencilInteraction, didReceiveTap tap: UIPencilInteraction.Tap) {
        handleAction(UIPencilInteraction.preferredTapAction)
    }

    @available(iOS 17.5, *)
    func pencilInteraction(_ interaction: UIPencilInteraction, didReceiveSqueeze squeeze: UIPencilInteraction.Squeeze) {
        guard UIPencilInteraction.preferredSqueezeAction == .showContextualPalette else {
            if squeeze.phase == .ended {
                handleAction(UIPencilInteraction.preferredSqueezeAction)
            }

            return
        }

        handlePaletteSqueeze(squeeze)
    }
}

//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Logging

/// Runs Seek and Destroy: presenting the search UI appropriate to the
/// current device, previewing matches as the user types, and redacting the
/// matches when the user finishes.
final class PhotoEditingSeekController: PhotoEditingChainedResponder, UIPopoverPresentationControllerDelegate {
    init(photoEditingView: PhotoEditingScrollView) {
        self.photoEditingView = photoEditingView
        super.init()
    }

    let seekBar = SeekBar()

    private var isSeeking = false {
        didSet {
            seekBar.isSeeking = isSeeking
        }
    }

    // MARK: Actions

    @objc func toggleSeeking(_ sender: Any) {
        if isSeeking {
            cancelSeeking(sender)
        } else {
            startSeeking(sender)
        }
    }

    @objc func startSeeking(_ sender: Any) {
        isSeeking = true

        #if targetEnvironment(macCatalyst)
        editingViewController?.present(DesktopSeekViewController(), animated: true, completion: nil)
        #else
        if editingViewController?.traitCollection.horizontalSizeClass == .regular {
            let seekViewController = TabletSeekViewController()
            seekViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            seekViewController.popoverPresentationController?.delegate = self
            editingViewController?.present(seekViewController, animated: true)
        } else {
            seekBar.becomeFirstResponder()
        }
        #endif
    }

    @objc func cancelSeeking(_ sender: Any) {
        isSeeking = false

        photoEditingView.seekPreviewObservations = []

        #if targetEnvironment(macCatalyst)
        if editingViewController?.presentedViewController is DesktopSeekViewController {
            editingViewController?.dismiss(animated: true, completion: nil)
        }
        #else
        seekBar.resignFirstResponder()
        seekBar.searchTextField?.text = nil

        if editingViewController?.presentedViewController is TabletSeekViewController {
            editingViewController?.dismiss(animated: true, completion: nil)
        }

        editingViewController?.becomeFirstResponder()
        #endif
    }

    @objc func finishSeeking(_ sender: Any) {
        logger.log(Event(name: "PhotoEditingViewController.finishSeeking"))
        photoEditingView.redact(photoEditingView.seekPreviewObservations, joinSiblings: false)
        if photoEditingView.seekPreviewObservations.count > 0 { editingViewController?.markHasMadeEdits() }
        cancelSeeking(sender)
    }

    @objc func seekBarDidChangeText(_ sender: UISearchTextField) {
        guard let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }

        let redactedCharacterObservations = photoEditingView.redactableCharacterObservations.matching(text)
        photoEditingView.seekPreviewObservations = redactedCharacterObservations
    }

    // MARK: Trait Changes

    func updateSeekPresentation() {
        #warning("#24: Move text between tablet and phone presentations")
        cancelSeeking(self)
    }

    // MARK: UIPopoverPresentationControllerDelegate

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        cancelSeeking(presentationController)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: Boilerplate

    @Injected(\.logger) private var logger
    private let photoEditingView: PhotoEditingScrollView
}
